//
//  CustomAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 14.01.2024.
//

import SwiftUI

struct CustomAlertView: View {
    
    // MARK: - Properties
    @Binding var wordSwipeData: [(word: String, swiped: Bool, isLastWord: Bool)]
    @Binding var points: Int
    @State private var language = LocalizationService.shared.language
    @State private var selectedTeamForLastWord: String? = nil
    @State private var isTeamInfoActive = false
    
    @EnvironmentObject var wordsAndTeamsManager: WordsAndTeamsManager
    @EnvironmentObject var gameSettingsManager: GameSettingsManager
    @EnvironmentObject var persistenceManager: PersistenceManager
    
    // MARK: - Computed Properties
    private var calculatedPoints: Int {
        wordSwipeData.filter { !$0.isLastWord }.reduce(0) { $0 + ($1.swiped ? 1 : -1) }
    }
    
    // MARK: - View Body
    var body: some View {
        VStack {
            currentTeamTitle
            wordList
            pointsDisplay
            nextButton
        }
        .navigationDestination(isPresented: $isTeamInfoActive) {
            TeamInfoView()
                .environmentObject(wordsAndTeamsManager)
                .environmentObject(gameSettingsManager)
                .environmentObject(persistenceManager)
                .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Subviews
    private var currentTeamTitle: some View {
        Text(wordsAndTeamsManager.teams[wordsAndTeamsManager.currentTeamIndex])
            .foregroundStyle(Color.blue)
            .font(.title)
            .padding()
    }
    
    private var wordList: some View {
        List {
            ForEach($wordSwipeData.indices, id: \.self) { index in
                WordRow(wordData: $wordSwipeData[index], selectedTeamForLastWord: $selectedTeamForLastWord)
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
    }
    
    private var pointsDisplay: some View {
        Text("Points: %lld".localized(language, args: calculatedPoints))
            .font(.title)
            .foregroundStyle(Color.blue)
            .padding()
    }
    
    private var nextButton: some View {
        CustomButton(name: "Next".localized(language)) {
            handleNextButtonTap()
        }
        .padding()
    }
    
    // MARK: - Methods
    private func handleNextButtonTap() {
        // Update points for the current team based on swiped words excluding the last word.
        wordsAndTeamsManager.updateTeamPoints(team: wordsAndTeamsManager.teams[wordsAndTeamsManager.currentTeamIndex], points: calculatedPoints)
        
        // Check if the last word was correctly swiped and a team was selected for it.
        if let selectedTeam = selectedTeamForLastWord,
           let lastWord = wordSwipeData.first(where: { $0.isLastWord }),
           lastWord.swiped {
            // Update points for the selected team for the last word.
            wordsAndTeamsManager.updateTeamPoints(team: selectedTeam, points: 1)
        }
        
        // Navigate to the next screen.
        isTeamInfoActive = true
    }
}

// MARK: - WordRow Subview
struct WordRow: View {
    @Binding var wordData: (word: String, swiped: Bool, isLastWord: Bool)
    @Binding var selectedTeamForLastWord: String?
    @State private var language = LocalizationService.shared.language
    
    @EnvironmentObject var wordsAndTeamsManager: WordsAndTeamsManager
    @EnvironmentObject var gameSettingsManager: GameSettingsManager
    @EnvironmentObject var persistenceManager: PersistenceManager
    
    var body: some View {
        HStack {
            Text(wordData.word)
                .foregroundStyle(Color.blue)
            Spacer()
            if wordData.swiped && !wordData.isLastWord {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.blue)
            }
            if wordData.isLastWord && wordData.swiped {
                teamPicker
            }
        }
        .onTapGesture {
            if !wordData.isLastWord {
                wordData.swiped.toggle()
            }
        }
    }
    
    private var teamPicker: some View {
        Picker("Select a team", selection: $selectedTeamForLastWord) {
            Text("Choose a team".localized(language)).tag(String?.none)
            ForEach(wordsAndTeamsManager.teams, id: \.self) { team in
                Text(team).tag(team as String?)
            }
        }
        .pickerStyle(MenuPickerStyle())
    }
}


// MARK: - Preview

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        // Corrected preview setup
        CustomAlertView(wordSwipeData: .constant([(word: "Example", swiped: false, isLastWord: false)]), points: .constant(0))
            .environmentObject(GameViewModel())
    }
}
