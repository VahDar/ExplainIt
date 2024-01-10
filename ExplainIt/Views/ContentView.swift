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
    @State private var selectedDuration = 30
    @State private var numberOfTeams = 0
    let viewModel = GameViewModel()
    var timerDurations: [Int]
    
    init(selectedDuration: Int, timerDurations: [Int]) {
            self._selectedDuration = State(initialValue: selectedDuration)
            self.timerDurations = timerDurations
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                    CustomButton(name: "Continue") {
                        isGameScreenActive = true
                    }
                    .padding(.bottom)
                
                    CustomButton(name: "New game") {
                        isSetUpScreenActive = true
                    }
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .navigationDestination(isPresented: $isGameScreenActive) {
                GameScreen(selectedDuration: $selectedDuration, timerDurations: timerDurations, viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isSetUpScreenActive) {
                SetUpScreen(selectedNumberOfTeams: $numberOfTeams, selectedDuration: $selectedDuration, viewModel: viewModel)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ContentView()
//    }
//}
