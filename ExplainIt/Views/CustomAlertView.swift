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
    private var calculatedPoints: Int {
        wordSwipeData.filter { $0.swiped }.count
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
            Text("Poits: \(calculatedPoints)")
                .font(.title)
                .foregroundStyle(Color.blue)
                .padding()
        }
    }
}

//#Preview() {
//    @State var viewModel = GameViewModel()
//    CustomAlertView(wordSwipeData: $viewModel.swipedWords)
//}
