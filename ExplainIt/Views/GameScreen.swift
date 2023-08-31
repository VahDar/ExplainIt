//
//  GameScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 31.08.2023.
//

import SwiftUI

struct GameScreen: View {
   
    @State private var isViewVisible = false

    var body: some View {
        VStack {
            if !isViewVisible {
                Button("Start") {
                    isViewVisible = true
                }
                
            }
            if isViewVisible {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 300, height: 300)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}

