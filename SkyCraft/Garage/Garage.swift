//
//  Garage.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 20/05/23.
//

import SwiftUI
import SpriteKit

struct Garage: View {
    @EnvironmentObject var playerApplication: PlayerHandler
    @Binding var isActive: Bool
    @State private var aChoice = 0
    @State private var bChoice = 0
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("background")
                    .scaleEffect(1.5)
//                    .scaledToFit()
                    .ignoresSafeArea()
                
                VStack{
                    // Aircraft Choice
                    Text("Aircraft")
                        .font(.bodyStyle)
                        .foregroundColor(Color.primaryYellow)
                    pickAircraft(choice: $aChoice)
                        .frame(height: 150)
                        .padding(.bottom, 50)
                    
                    // Bullet Type Choice
                    Text("Blaster")
                        .font(.bodyStyle)
                        .foregroundColor(Color.primaryYellow)
                    PickBlaster(choice: $bChoice)
                        .frame(height: 150)
                        .padding(.bottom, 60)
                    
//                    Button {
//                        chooseAircraft(choice: userChoice) // remove later
//                        print("aircraft type: \(aircraftChoice.integer(forKey: "aircraftType"))")
//                    } label: {
//                        Text("Trial button")
//                            .foregroundColor(.red)
//                    }
                                         
                    // Save
                    Button {
                        print("choice: \(aChoice), \(bChoice)")
                        playerApplication.setAircraftType(type: aChoice )
                        playerApplication.setBlasterType(type: bChoice )
                        isActive = false
                        print("player: \(playerApplication.aircraftType) | \(playerApplication.blasterType)")
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(RoundedButtonStyle())
                    
//                    NavigationLink {
//                        MainScreen().navigationBarBackButtonHidden(true)
//                    } label: {
//                        Text("Save")
//                    }
//                    .buttonStyle(RoundedButtonStyle())
//                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    // VM Part, pls help me move this
    func chooseAircraft(choice: Int) {
        aircraftChoice.set(choice, forKey: "aircraftType")
    }
}

//struct Garage_Previews: PreviewProvider {
//    static var previews: some View {
//        Garage()
//    }
//}
