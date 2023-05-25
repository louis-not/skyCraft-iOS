//
//  testview.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 23/05/23.
//

import SwiftUI

struct testview: View {
    @EnvironmentObject var newSession: MultipeerSession
    
    var body: some View {
        VStack {
            
            Text("Send Data")
            
            Button {
                newSession.send(bullet: Bullet(type: "gun", x: 231, delayTime: 1, dist: 234, angle: 0))
            } label: {
                Text("   Press   ")
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

struct testview_Previews: PreviewProvider {
    static var previews: some View {
        testview()
    }
}
