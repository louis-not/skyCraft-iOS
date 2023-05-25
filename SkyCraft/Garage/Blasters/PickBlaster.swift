//
//  PickBlaster.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 22/05/23.
//

import SwiftUI

struct PickBlaster: View {
    @Binding var choice: Int
    let blasters: [String] = ["gun", "Cannon", "laser", "Shells"]
    
    var body: some View {
        TabView (selection: $choice){
            ForEach(0..<blasters.count, id:\.self) {
                index in
                BlasterCard(blasterName: .constant(blasters[index]))
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .foregroundColor(Color.darkPurple)
    }
}

struct BlasterCard: View {
    @Binding var blasterName: String
    
    var body: some View {
        ZStack {
            Rectangle()
            VStack {
                Image(blasterName)
                Text(blasterName)
                    .font(.smallStyle)
                    .foregroundColor(.white)
            }
        }
    }
}

//struct PickBlaster_Previews: PreviewProvider {
//    static var previews: some View {
//        PickBlaster()
//    }
//}
