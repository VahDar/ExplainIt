//
//  TeamInfoView.swift
//  ExplainIt
//
//  Created by Vakhtang on 18.01.2024.
//

import SwiftUI

struct TeamInfoView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            Text("Required points: %lld".localized(language, args: viewModel.requiredPoints))
                .foregroundStyle(Color.blue)
                .font(.title)
                .padding()
            List(viewModel.teams, id: \.self) { team in
                HStack {
                    Text(team)
                        .foregroundStyle(Color.blue)
                    Spacer()
                    Text("%lld points".localized(language, args: viewModel.teamPoints[team, default: 0]))
                        .foregroundStyle(Color.blue)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            
            CustomButton(name: "Next Team".localized(language)) {
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
