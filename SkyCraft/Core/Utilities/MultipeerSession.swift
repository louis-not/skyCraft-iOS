import MultipeerConnectivity
import os

struct SentData: Codable {
    var desc: SentDataDescription
    var content: Bullet
    var winner: Bool
    
    enum SentDataDescription: Codable {
        case bullet
        case game
    }
}

class MultipeerSession: NSObject, ObservableObject {
    
    //    @EnvironmentObject var playerApplication: PlayerHandler
//    @Published private var game = GameScene()
    
    private let serviceType = "skyCraft"
    public var myPeerID: MCPeerID
    public var myOpponentID: MCPeerID
    
    public let serviceAdvertiser: MCNearbyServiceAdvertiser
    public let serviceBrowser: MCNearbyServiceBrowser
    public let session: MCSession
    
    private let log = Logger()
    
    @Published var availablePeers: [MCPeerID] = []
    @Published var recvdBullet: Bullet = Bullet(type: "gun", x: 50.0, delayTime: 0.5, dist: 200, angle: 0)
    @Published var recvdInvite: Bool = false
    @Published var recvdInviteFrom: MCPeerID? = nil
    @Published var paired: Bool = false
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    @Published var myHealth: Double = 100.0
    @Published var enemyHealth: Int = 3
    @Published var myName: String = ""
    @Published var enemyName: String = ""
    @Published var gameOver: Bool = false
    
    
    init(username: String) {
        let peerID = MCPeerID(displayName: username)
        self.myPeerID = peerID
        self.myOpponentID = peerID
        self.recvdInviteFrom = nil
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        log.info("deinit success")
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func send(bullet: Bullet){
//        if !session.connectedPeers.isEmpty {
//            let data = convertBulletToData(bullet: bullet)
//            log.info("send Attack to \(self.session.connectedPeers[0].displayName)")
//            do {
//                try session.send(data!, toPeers: session.connectedPeers, with: .reliable)
//            } catch {
//                log.error("Error sending: \(String(describing: error))")
//            }
//        }
        let sentData = SentData(desc: .bullet, content: bullet, winner: gameOver)
        
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(sentData)
            
            try session.send(encodedData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            log.error("Failed to send bullet info")
        }
    }
    
}

extension MultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            print("1. Connected to peer: \(peerID.displayName)")
            
            switch state {
            case MCSessionState.notConnected:
                // Peer disconnected
                
                DispatchQueue.main.async {
                    // Flush
                    self.myName = ""
                    self.enemyName = ""
                    self.paired = false
                }
                // Peer disconnected, start accepting invitaions again
                serviceAdvertiser.startAdvertisingPeer()
                break
            case MCSessionState.connected:
                // Peer connected
                DispatchQueue.main.async {
                    self.paired = true
                    self.myOpponentID = self.session.connectedPeers[0]
                }
                // We are paired, stop accepting invitations
                serviceAdvertiser.stopAdvertisingPeer()
                break
            default:
                // Peer connecting or something else
                DispatchQueue.main.async {
                    self.paired = false
                }
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Handle received data from peers
        print("2. Received data from peer \(peerID)")
        let jsonDecoder = JSONDecoder()

        // Try to decode a 'SentData' object from received data.
        if let sentData = try? jsonDecoder.decode(SentData.self, from: data) {
            print("received: \(sentData.content.type),\(sentData.content.x), \(sentData.content.dist)")
            
            // send to sprite kit to received attack
            DispatchQueue.main.async {
                self.recvdBullet = Bullet(type: sentData.content.type,
                                     x: sentData.content.x,
                                     delayTime: sentData.content.delayTime,
                                     dist: sentData.content.dist,
                                     angle: sentData.content.angle)
                print("recvd bullet in mc: \(self.recvdBullet.x)")
                self.gameOver = sentData.winner
            }
        } else {
            // If unable to decode data as 'SentData', print the result
            print("Did not receive 'SentData' object")
        }    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Handle received streams from peers
        log.error("Receiving resources is not supported")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Handle started receiving a resource from a peer
        log.error("Receiving resources is not supported")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Handle finished receiving a resource from a peer
        log.error("Receiving resources is not supported")
    }

    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}

extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //TODO: Inform the user something went wrong and try again
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        
        DispatchQueue.main.async {
            // Tell PairView to show the invitation alert
            self.recvdInvite = true
            GameData.shared.recvdInvite = true
            // Give PairView the peerID of the peer who invited us
            self.recvdInviteFrom = peerID
            // Give PairView the `invitationHandler` so it can accept/deny the invitation
            self.invitationHandler = invitationHandler
        }
    }
}

extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //TODO: Tell the user something went wrong and try again
        log.error("ServiceBroser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        // Add the peer to the list of available peers
        DispatchQueue.main.async {
            self.availablePeers.append(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
        // Remove lost peer from list of available peers
        DispatchQueue.main.async {
            self.availablePeers.removeAll(where: {
                $0 == peerID
            })
        }
    }
}
