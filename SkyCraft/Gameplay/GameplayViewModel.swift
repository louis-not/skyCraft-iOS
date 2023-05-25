//
//  GameplayViewModel.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 21/05/23.
//

import SwiftUI

class GameplayViewModel: NSObject, ObservableObject {
    @EnvironmentObject var playerApplication: PlayerHandler
    @Published private var game = GameScene()
    
}
