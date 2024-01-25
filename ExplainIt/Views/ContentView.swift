//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {

    @State private var isGameScreenActive = false
    @State private var isTeamScreenActive = false
    @State private var selectedDuration = 30
    @State private var numberOfTeams = 0
    @StateObject var viewModel = GameViewModel()
    var timerDurations: [Int]
    
    init(selectedDuration: Int, timerDurations: [Int]) {
            self._selectedDuration = State(initialValue: selectedDuration)
            self.timerDurations = timerDurations
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                    CustomButton(name: "Continue") {
                        viewModel.loadGameData()
                    }
                    .padding(.bottom)
                
                    CustomButton(name: "New game") {
                        isTeamScreenActive = true
                    }
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            
            .navigationDestination(isPresented: $isTeamScreenActive) {
                TeamName(timerDurations: timerDurations)
                    .environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $viewModel.isGameScreenPresented) {
                GameScreen().environmentObject(viewModel)
            }
            .navigationDestination(isPresented: $viewModel.isWinnerActive) {
                WinnerAlertView().environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.loadGameData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var selectedDuration = 30
    @State static var timerDurations = [30]
    static var previews: some View {
        ContentView(selectedDuration: selectedDuration, timerDurations: timerDurations)
    }
}
