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
    @State private var selectedTeamForLastWord: String?
    @State private var isTeamInfoActive = false
    private var calculatedPoints: Int {
        wordSwipeData.reduce(0) { result, data in
            result + (data.swiped ? 1 : -1)
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
                        if wordSwipeData[index].swiped {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.blue)
                        }
                        if wordSwipeData[index].isLastWord {
                            Picker("Select Team", selection: $selectedTeamForLastWord) {
                                ForEach(viewModel.teams, id: \.self) { team in
                                    Text(team).tag(team as String?)
                                        .foregroundStyle(Color.blue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedTeamForLastWord) { newValue in
                                if let teamName = newValue {
                                    viewModel.updateTeamPoints(team: teamName, points: 1) // Начисляем 1 очко выбранной команде за последнее слово
                                    wordSwipeData[index].isLastWord = false // Сбрасываем флаг последнего слова
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        wordSwipeData[index].swiped.toggle()
                        points = calculatedPoints
//                        viewModel.objectWillChange.send()
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            Text("Poits: \(calculatedPoints)")
                .font(.title)
                .foregroundStyle(Color.blue)
                .padding()
            CustomButton(name: "Next") {
                viewModel.updateTeamPoints(team: viewModel.teams[viewModel.currentTeamIndex], points: calculatedPoints)
                isTeamInfoActive = true
                var transaction = Transaction()
                transaction.disablesAnimations = true
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
