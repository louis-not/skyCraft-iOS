//
//  Button.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 18/05/23.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .frame(width: 310, height: 56)
//            .border(Color.primaryOrange,width:3)
            .font(.custom("VT323-Regular", size: 24))
            .background(Color.primaryYellow)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.darkYellow, lineWidth: 3)
            )
    }
}

struct RoundedButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
        }, label: {
            Text("Next")
        })
        .buttonStyle(RoundedButtonStyle())
    }
}
