//
//  AircraftCard.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 22/05/23.
//

import SwiftUI

struct AircraftCard: View {
    @Binding var aircraftName: String
    
    var body: some View {
        ZStack {
            Rectangle()
            Image(aircraftName)
        }
    }
}

struct AircraftCard_Previews: PreviewProvider {
    static var previews: some View {
        AircraftCard(aircraftName: .constant("Aircraft 3"))
    }
}
