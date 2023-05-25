//
//  MainScreen.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 18/05/23.
//

import SwiftUI
import SpriteKit

var aircraftChoice = UserDefaults.standard

struct MainScreen: View {
    @EnvironmentObject var playerApplication: PlayerHandler
    @State private var isGarageActive = false
    @State private var isMatchActive = false
    @State private var isGameActive = false
    @State private var username: String = ""
    @State var newSession: MultipeerSession?
    
    var body: some View {
        NavigationView(){
            if !isMatchActive {
                ZStack {
                    Image("background")
                        .scaledToFill()
                        .scaleEffect(1.5)
                        .ignoresSafeArea()
                    
                    VStack {
                        // Image for aircraft
                        Image(playerApplication.aircraftType)
                            .padding(.bottom, 98)
                        
                        // name textfield
                        TextField("Enter your name", text: $username, onCommit: {
                            playerApplication.setUsername(input: username)
                            GameData.shared.username = username
                            print("player name: \(playerApplication.username)")
                        })
                            .textFieldStyle(CustomTextFieldStyle())

                        Rectangle()
                            .frame(width: 230, height: 3)
                            .foregroundColor(Color.primaryOrange)
                            .padding(.bottom, 136)
                        
                        // Start Button
                        Button(action: {
                            isGameActive = true
                            isMatchActive = true
                            
                            GameData.shared.myAircraft = playerApplication.aircraftType
                            GameData.shared.myBlaster = playerApplication.blasterType
                            GameData.shared.gameOver = false
                            
                            print("Starting new peer \(playerApplication.username)")
                            newSession = MultipeerSession(username: playerApplication.username)
                        }) {
                            Text("Start")
                        }
                        .buttonStyle(RoundedButtonStyle())
                        .padding(.bottom, 24)
//                        .fullScreenCover(isPresented: $isGameActive, content: {
//    //                        Gameplay(gameplayVM: GameplayViewModel())
//    //                            .environmentObject(playerApplication)
//    //                            .navigationBarBackButtonHidden(true)
//                            Matchmaking(gameplayVM: GameplayViewModel())
//                                .environmentObject(newSession!)
//
//                        })
                        
                        // Garage Button
                        Button(action: {
                            isGarageActive = true
                        }) {
                            Text("Garage")
                        }
                        .buttonStyle(RoundedButtonStyle())
                        .fullScreenCover(isPresented: $isGarageActive, content: {
                            Garage(isActive: $isGarageActive)
                        })
    //                    NavigationLink {
    //                        Garage().navigationBarBackButtonHidden(true)
    //                    } label: {
    //                        Text("Garage")
    //                    }
    //                    .buttonStyle(RoundedButtonStyle())
                        
                    }
                }

            }
            else {
                Matchmaking()
                    .environmentObject(newSession!)
            }
        }
    }
    
}

//struct MainScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        MainScreen()
//    }
//}
