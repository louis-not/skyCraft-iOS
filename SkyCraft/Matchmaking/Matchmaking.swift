//
//  Matchmaking.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 18/05/23.
//

import SwiftUI
import os

@available(iOS 15.0, *)
struct Matchmaking: View {
    @EnvironmentObject var playerApplication: PlayerHandler
    @EnvironmentObject var newSession: MultipeerSession
    @State var isSessionRecvd = true
    
//    init(){
//        GameData.shared.newSession = MultipeerSession(username: GameData.shared.username)
//        newSession = GameData.shared.newSession
//    }
    
    var body: some View {
        NavigationView {
            if (!newSession.paired) {
                VStack {
                    Text("Available Opponents")
                    
                    Text("my name is \(playerApplication.username)")
                    
                    List(newSession.availablePeers, id: \.self) { peer in
                        Button {
                            // action
                            newSession.serviceBrowser.invitePeer(peer, to: newSession.session, withContext: nil, timeout: 30)
                        } label: {
                            Text(peer.displayName)
                        }
                        .foregroundColor(.blue)
                    }
                }
                .alert("Received an invite from \(newSession.recvdInviteFrom?.displayName ?? "TEST")!", isPresented: $newSession.recvdInvite) {
                    Button("Accept invite") {
                        if (newSession.invitationHandler != nil) {
                            newSession.invitationHandler!(true, newSession.session)
                            print("accepted invitation")
                        }
                    }
                    Button("Reject invite") {
                        if (newSession.invitationHandler != nil) {
                            newSession.invitationHandler!(false, nil)
                            print("rejected invitation")
                        }
                    }
                }
            } else {
//                testview()
//                    .environmentObject(newSession)
                Gameplay()
                    .environmentObject(playerApplication)
                    .environmentObject(newSession)
            }
        }
        .background(Color.darkPurple)
    }
}

//struct Matchmaking_Previews: PreviewProvider {
//    static var previews: some View {
//        Matchmaking(gameplayVM: GameplayViewModel())
//    }
//}
