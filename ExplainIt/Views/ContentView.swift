//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    @State private var isTeamScreenActive = false
    @State private var isUkrainian = false
    @State private var selectedDuration: Int
    
    @EnvironmentObject var wordsAndTeamsManager: WordsAndTeamsManager
    @EnvironmentObject var gameSettingsManager: GameSettingsManager
    @EnvironmentObject var persistenceManager: PersistenceManager

    var timerDurations: [Int]
    
    
    // MARK: - Initializer
    
    init(selectedDuration: Int, timerDurations: [Int]) {
        self._selectedDuration = State(initialValue: selectedDuration)
        self.timerDurations = timerDurations
        self._isUkrainian = State(initialValue: LocalizationService.shared.language == .ukrainian)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                gameSettingsView
                languageSelectionView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundAnimationView)
            .onChange(of: isUkrainian, perform: updateLanguage)
            .onAppear(perform: persistenceManager.loadGameData)
            .navigationDestination(isPresented: $isTeamScreenActive) {
                TeamName(timerDurations: timerDurations)
                    .environmentObject(wordsAndTeamsManager)
                    .environmentObject(gameSettingsManager)
                    .environmentObject(persistenceManager)
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $wordsAndTeamsManager.isGameScreenPresented) {
                GameScreen()
                    .environmentObject(wordsAndTeamsManager)
                    .environmentObject(gameSettingsManager)
                    .environmentObject(persistenceManager)
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $wordsAndTeamsManager.isWinnerActive) {
                WinnerAlertView()
                    .environmentObject(wordsAndTeamsManager)
                    .environmentObject(gameSettingsManager)
                    .environmentObject(persistenceManager)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    // MARK: - View Components
    
    private var languageSelectionView: some View {
        VStack {
            Text("Language".localized(language))
                .foregroundStyle(Color(red: 79/255, green: 74/255, blue: 183/255))
                .font(.title.bold())
            HStack {
                Button(action: { isUkrainian.toggle() }) {
                    Image(systemName: "chevron.left")
                }
                .padding()
                
                LanguageImage(isUkrainian: $isUkrainian)
                    .frame(width: 30, height: 30)
                
                Button(action: { isUkrainian.toggle() }) {
                    Image(systemName: "chevron.right")
                }
                .padding()
            }
        }
    }
    
    private var gameSettingsView: some View {
        VStack {
            TextGradient()
                .padding()
                .offset(y: -120)
            SettingAnimationView(animationFileName: "astronautMain", loopMode: .loop)
                .frame(width: 100, height: 100)
                .scaleEffect(0.25)
                .padding(.bottom)
                .offset(y: -35)
            
            CustomButton(name: "New Game".localized(language)) {
                isTeamScreenActive = true
                persistenceManager.clearGameData()
                gameSettingsManager.resetGame()
            }
            .padding(.bottom)
            
            CustomDisabledButton(name: "Continue".localized(language), action: {
                isTeamScreenActive = false
                wordsAndTeamsManager.isGameScreenPresented = true
            }, isDisabled: !gameSettingsManager.isGameStarted)
            .padding(.bottom)
        }
    }
    
    private var backgroundAnimationView: some View {
        SettingAnimationView(animationFileName: "backgroundAnimation", loopMode: .loop)
            .allowsHitTesting(false)
    }
    
    // MARK: - Methods
    
    private func updateLanguage(newValue: Bool) {
        language = newValue ? .ukrainian : .english_us
    }
    
    // MARK: - Preview
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView(selectedDuration: 30, timerDurations: [30, 60, 90])
        }
    }
}

// Assuming LanguageImage is a struct for displaying the language flag
struct LanguageImage: View {
    @Binding var isUkrainian: Bool
    
    var body: some View {
        Image(isUkrainian ? "UA" : "USA")
            .resizable()
    }
}
