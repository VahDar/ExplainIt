//
//  CustomAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 14.01.2024.
//

import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Binding var wordSwipeData: [(word: String, swiped: Bool, isLastWord: Bool)]
    @Binding var points: Int
    @State private var selectedTeamForLastWord: String? = nil
    @State private var lastWordPointsAssigned = false
    @State private var isTeamInfoActive = false
    private var calculatedPoints: Int {
        wordSwipeData.filter { !$0.isLastWord }.reduce(0) { $0 + ($1.swiped ? 1: -1)
        }
    }
    
    var body: some View {
        VStack {
            Text("\(viewModel.teams[viewModel.currentTeamIndex])")
                .foregroundStyle(Color.blue)
                .font(.title)
                .padding()
            List {
                ForEach($wordSwipeData.indices, id: \.self) { index in
                    HStack {
                        Text(wordSwipeData[index].word)
                            .foregroundStyle(Color.blue)
                        Spacer()
                        if wordSwipeData[index].swiped && !wordSwipeData[index].isLastWord {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.blue)
                        }
                        if wordSwipeData[index].isLastWord  && wordSwipeData[index].swiped {
                            Picker("Select a team", selection: $selectedTeamForLastWord) {
                                Text("Choose a team").tag(String?.none)
                                ForEach(viewModel.teams, id: \.self) { team in
                                    Text(team).tag(team as String?)
                                        .foregroundStyle(Color.blue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedTeamForLastWord) { newValue in
                                if let teamName = newValue {
                                    viewModel.updateTeamPoints(team: teamName, points: 0)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        if !wordSwipeData[index].isLastWord {
                            wordSwipeData[index].swiped.toggle()
                            points = calculatedPoints
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            Text("Points: \(calculatedPoints)")
                .font(.title)
                .foregroundStyle(Color.blue)
                .padding()
            CustomButton(name: "Next") {
                viewModel.updateTeamPoints(team: viewModel.teams[viewModel.currentTeamIndex], points: calculatedPoints)
                if let selectedTeam = selectedTeamForLastWord, let lastWord = wordSwipeData.first(where: { $0.isLastWord }) {
                    if lastWord.swiped {
                        // Если последнее слово угадано, добавляем очко выбранной команде
                        viewModel.updateTeamPoints(team: selectedTeam, points: 1)
                    }
                }
                isTeamInfoActive = true
            }
            .padding()
        }
        .navigationDestination(isPresented: $isTeamInfoActive) {
            TeamInfoView()
                .environmentObject(viewModel)
        }
    }
}

//#Preview() {
//    @State var viewModel = GameViewModel()
//    CustomAlertView(wordSwipeData: $viewModel.swipedWords)
//}
