//
//  SkyCraftApp.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 18/05/23.
//

import SwiftUI

@main
struct SkyCraftApp: App {
    let playerApplication = PlayerHandler()
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(playerApplication)
//            Gameplay()
        }
    }
}
