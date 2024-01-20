//
//  TeamInfoView.swift
//  ExplainIt
//
//  Created by Vakhtang on 18.01.2024.
//

import SwiftUI

struct TeamInfoView: View {
    @EnvironmentObject var viewModel: GameViewModel
//    @Binding var isActive: Bool
    var body: some View {
        List(viewModel.teams, id: \.self) { team in
            HStack {
                Text(team)
                    .foregroundStyle(Color.blue)
                Spacer()
                Text("\(viewModel.teamPoints[team, default: 0]) points")
                    .foregroundStyle(Color.blue)
            }
        }
        CustomButton(name: "Next Team") {
            viewModel.moveToNextTeam()
        }
        .padding()
    }
}

#Preview {
    TeamInfoView()
}
