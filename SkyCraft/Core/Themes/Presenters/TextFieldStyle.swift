//
//  TextFieldStyle.swift
//  SkyCraft
//
//  Created by Louis Mayco Dillon Wijaya on 18/05/23.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(width: 230, alignment: .center)
            .font(.custom("VT323-Regular", size: 30))
            .foregroundColor(Color.primaryOrange)
            .background(Color.darkPurple)
            .multilineTextAlignment(.center)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextField("Enter your name", text: .constant(""))
            .textFieldStyle(CustomTextFieldStyle())
    }
}
