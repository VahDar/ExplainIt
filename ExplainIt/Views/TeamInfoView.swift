//
//  TeamInfoView.swift
//  ExplainIt
//
//  Created by Vakhtang on 18.01.2024.
//

import SwiftUI

struct TeamInfoView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        VStack {
            Text("Required points: \(viewModel.requiredPoints)".localized)
                .foregroundStyle(Color.blue)
                .font(.title)
                .padding()
            List(viewModel.teams, id: \.self) { team in
                HStack {
                    Text(team)
                        .foregroundStyle(Color.blue)
                    Spacer()
                    Text("\(viewModel.teamPoints[team, default: 0]) points".localized)
                        .foregroundStyle(Color.blue)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            
            CustomButton(name: "Next Team".localized) {
                viewModel.moveToNextTeam()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
    }
}

#Preview {
    TeamInfoView()
}
