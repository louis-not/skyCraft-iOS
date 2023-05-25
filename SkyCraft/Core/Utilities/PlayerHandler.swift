//
//  PlayerHandler.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 21/05/23.
//

import Foundation

class PlayerHandler: ObservableObject {
    // For every player
    @Published var username = ""
    @Published var aircraftType = "Aircraft 1"
    @Published var blasterType = "gun"
    
    func setUsername(input: String){
        self.username = input
    }
    
    func setAircraftType(type: Int){
        switch type {
        case 0:
            self.aircraftType = "Aircraft 1"
        case 1:
            self.aircraftType = "Aircraft 2"
        case 2:
            self.aircraftType = "Aircraft 3"
        case 3:
            self.aircraftType = "Aircraft 4"
        default:
            self.aircraftType = "Aircraft 1"
        }
        print("set to \(self.aircraftType)")
    }
    
    func setBlasterType(type: Int){
        switch type {
        case 0:
            self.blasterType = "gun"
        case 1:
            self.blasterType = "Cannon"
        case 2:
            self.blasterType = "laser"
        case 3:
            self.blasterType = "Shells"
        default:
            self.blasterType = "gun"
        }
        print("set to \(self.blasterType)")
    }
}
