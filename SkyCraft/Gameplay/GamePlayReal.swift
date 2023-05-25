//
//  Gameplay.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 18/05/23.
//

import SwiftUI
import SpriteKit


struct Gameplay: View {
    @EnvironmentObject var playerApplication: PlayerHandler
    @EnvironmentObject var newSession: MultipeerSession
    var scene: GameScene {
        let game = GameScene(multi: newSession, minX: 0, maxX: 0, minY: 0, maxY: 0, bulletGun: SKSpriteNode(), yTresshold: 0, yTuning: 0)
//        game.multi = newSession
        return game
    }
    
    var body: some View {
        NavigationView {
            HStack {
                ZStack {
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                    
                    if newSession.gameOver {
                        // gameOver, back to result
                        NavigationLink {
                            MainScreen().navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Main Menu")
                        }
                        .buttonStyle(RoundedButtonStyle())
                        .padding(.top, 300)
                    } 
                }
            }
        }
    }
}

//struct Gameplay_Previews: PreviewProvider {
//    static var previews: some View {
//        Gameplay()
//    }
//}
