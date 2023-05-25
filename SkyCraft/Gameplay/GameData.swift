//
//  GameData.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 23/05/23.
//

import Foundation
import MultipeerConnectivity
import SpriteKit

class GameData {
    static let shared = GameData()
    
    // playerName
    var username = ""
    
    // Customization
    var myAircraft = ""
    var myBlaster = ""
    
    // Game still goin?
    var gameOver = false
    
    // Multipeer
    var newSession: MultipeerSession = MultipeerSession(username: " ")
    var recvdInvite: Bool = false
    
    // Game Scene
//    var game: SKScene
    
    private init(){ }
}
