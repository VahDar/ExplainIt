//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {

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
                SettingAnimationView(animationFileName: "astronautMain", loopMode: .loop)
                    .frame(width: 100, height: 100)
                    .scaleEffect(0.2)
                    .padding(.bottom)
                CustomButton(name: "New Game".localized) {
                        isTeamScreenActive = true
                        viewModel.clearGameData()
                        viewModel.resetGame()
                    }
                    .padding(.bottom)
                CustomButton(name: "Language") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                           UIApplication.shared.open(url)
                       }
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
