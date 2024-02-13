//
//  CustomAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 14.01.2024.
//

import SwiftUI

struct CustomAlertView: View {
    
    // MARK: - Properties
    @EnvironmentObject var viewModel: GameViewModel
    @Binding var wordSwipeData: [(word: String, swiped: Bool, isLastWord: Bool)]
    @Binding var points: Int
    @State private var language = LocalizationService.shared.language
    @State private var selectedTeamForLastWord: String? = nil
    @State private var isTeamInfoActive = false
    
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
                .environmentObject(viewModel)
                .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Subviews
    private var currentTeamTitle: some View {
        Text(viewModel.teams[viewModel.currentTeamIndex])
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
        viewModel.updateTeamPoints(team: viewModel.teams[viewModel.currentTeamIndex], points: calculatedPoints)
        
        // Check if the last word was correctly swiped and a team was selected for it.
        if let selectedTeam = selectedTeamForLastWord,
           let lastWord = wordSwipeData.first(where: { $0.isLastWord }),
           lastWord.swiped {
            // Update points for the selected team for the last word.
            viewModel.updateTeamPoints(team: selectedTeam, points: 1)
        }
        
        // Navigate to the next screen.
        isTeamInfoActive = true
    }
}

// MARK: - WordRow Subview
struct WordRow: View {
    @Binding var wordData: (word: String, swiped: Bool, isLastWord: Bool)
    @Binding var selectedTeamForLastWord: String?
    @EnvironmentObject var viewModel: GameViewModel
    @State private var language = LocalizationService.shared.language
    
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
            ForEach(viewModel.teams, id: \.self) { team in
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
