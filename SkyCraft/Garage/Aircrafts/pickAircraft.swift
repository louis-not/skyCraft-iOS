//
//  pickAircraft.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 20/05/23.
//

import SwiftUI

struct pickAircraft: View {
    @State private var selectedIndex = 0
    @Binding var choice: Int
    let aircrafts: [String] = ["Aircraft 1", "Aircraft 2", "Aircraft 3", "Aircraft 4"]
    
    var body: some View {
        TabView (selection: $choice) {
            ForEach(0..<aircrafts.count, id:\.self) {
                index in
                AircraftCard(aircraftName: .constant(aircrafts[index]))
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .foregroundColor(Color.darkPurple)
//        .onChange(of: choice, perform: <#T##(Equatable) -> Void##(Equatable) -> Void##(_ newValue: Equatable) -> Void#>)
//        .padding(.vertical, 16)
    }
}

//struct pickAircraft_Previews: PreviewProvider {
//    static var previews: some View {
//        pickAircraft()
//    }
//}
