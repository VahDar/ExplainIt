//
//  CustomButton.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct CustomButton: View {
    let name: String
    let action: () -> Void
    var body: some View {
        Button(name) {
            action()
        }
        .frame(width: 300, height: 60)
        .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255)
        )
        .shadow(color: Color(red: 36/255, green: 33/255, blue: 142/255), radius: 6, x: 0, y: 15)
        .font(.system(size: 25))
        .fontWeight(.bold)
        .background(
            GradientLineView()      
        )
        
        
  }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(name: "Start", action: {print("start")})
    }
}
