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
    var body: some View {
        VStack {
            Text("\(viewModel.teams[viewModel.currentTeamIndex])")
                .foregroundStyle(Color.blue)
            List {
                ForEach($wordSwipeData, id: \.word) { $data in
                    HStack {
                        Text(data.word)
                        Spacer()
                        if data.swiped {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    CustomAlertView(, wordSwipeData: <#Binding<[(word: String, swiped: Bool)]>#>)
//}
