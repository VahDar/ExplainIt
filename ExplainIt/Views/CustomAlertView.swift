//
//  CustomAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 14.01.2024.
//

import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Binding var wordSwipeData: [(word: String, swiped: Bool)]
    @Binding var points: Int
    @Binding var lastWordSwipedUp: Bool
    @Binding var lastSwipedWord: String
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
                ForEach($wordSwipeData, id: \.word) { $data in
                    HStack {
                        Text(data.word)
                            .foregroundStyle(Color.blue)
                        Spacer()
                        if data.swiped {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                        }
                    }
                    .onTapGesture {
                        data.swiped.toggle()
                        points = calculatedPoints
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            Text("Points: \(calculatedPoints)")
                .font(.title)
                .foregroundStyle(Color.blue)
                .padding()
            if lastWordSwipedUp {
                Text("Last word: \(lastSwipedWord)")
                
            }
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
