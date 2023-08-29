//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        CustomButton(name: "Start Game") {
                    print("play")
                }
        .padding(.bottom)
            
        CustomButton(name: "Set Up") {
                print("play")
            }
        .padding(.bottom)
        CustomButton(name: "Start Game") {
                print("play")
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            BackgroundView()
        )
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
