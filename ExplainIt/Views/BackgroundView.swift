//
//  BackgroundView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
       
        ZStack {
            Color.black.ignoresSafeArea()
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 39/255, green: 37/255, blue: 83/255),Color.black,Color(red: 39/255, green: 37/255, blue: 83/255),]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
