//
//  TeamInfoView.swift
//  ExplainIt
//
//  Created by Vakhtang on 18.01.2024.
//

import SwiftUI

struct TeamInfoView: View {
    @State private var language = LocalizationService.shared.language
    
    @EnvironmentObject var wordsAndTeamsManager: WordsAndTeamsManager
    @EnvironmentObject var gameSettingsManager: GameSettingsManager
    @EnvironmentObject var persistenceManager: PersistenceManager
    
    var body: some View {
        VStack {
            Text("Required points: %lld".localized(language, args: wordsAndTeamsManager.requiredPoints))
                .foregroundStyle(Color.blue)
                .font(.title)
                .padding()
            List(wordsAndTeamsManager.teams, id: \.self) { team in
                HStack {
                    Text(team)
                        .foregroundStyle(Color.blue)
                    Spacer()
                    Text("%lld points".localized(language, args: wordsAndTeamsManager.teamPoints[team, default: 0]))
                        .foregroundStyle(Color.blue)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            
            CustomButton(name: "Next Team".localized(language)) {
                wordsAndTeamsManager.moveToNextTeam()
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
