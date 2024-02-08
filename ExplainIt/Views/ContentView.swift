//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    @State private var isTeamScreenActive = false
    @State private var isUkrainian = false
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
                    .offset(y: -30)
                
                CustomButton(name: "New Game".localized(language)) {
                    isTeamScreenActive = true
                    viewModel.clearGameData()
                    viewModel.resetGame()
                }
                .padding(.bottom)
                
                HStack {
                    Button {
                        isUkrainian.toggle()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    if isUkrainian {
                        Image("UA")
                            .resizable()
                            .frame(width: 30, height: 30)
                    } else {                        Image("USA")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Button {
                        isUkrainian.toggle()
                    } label: {
                        Image(systemName: "chevron.right")
                    }

                }
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
        .onChange(of: isUkrainian) { newValue in
                    LocalizationService.shared.language = newValue ? .ukrainian : .english_us
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
