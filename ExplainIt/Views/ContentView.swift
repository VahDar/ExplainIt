//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isGameScreenActive = false
    @State private var isSetUpScreenActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: GameScreen(), isActive: $isGameScreenActive) {
                    CustomButton(name: "Start Game") {
                        isGameScreenActive = true
                    }
                    .padding(.bottom)
                }
                NavigationLink(destination: SetUpScreen(), isActive: $isSetUpScreenActive) {
                    CustomButton(name: "Set Up") {
                        isSetUpScreenActive = true
                    }
                    .padding(.bottom)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
