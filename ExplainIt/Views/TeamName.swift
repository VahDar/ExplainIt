//
//  TeamName.swift
//  ExplainIt
//
//  Created by Vakhtang on 08.01.2024.
//

import SwiftUI

struct TeamName: View {
    @State private var teamNames: [String] = []
    @State private var randomNames = ["Crazy cucumber", "Best", "Pony", "Just a winners", "Manatee"]
    @State private var isSetUpScreenActive = false
    @State private var isAlertPresented = false
    @State private var isWarningAlertPresented = false
    @State private var temporaryTeamName = ""
    @State private var editingTeamIndex: Int?
    @State private var numberOfTeams = 0
    @EnvironmentObject var viewModel: GameViewModel
    var timerDurations: [Int]
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<teamNames.count, id: \.self) { index in
                    HStack {
                        TextField("Team \(index + 1) Name".localized, text: $teamNames[index])
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundStyle(.white)
                        Spacer()
                        Text("Random".localized)
                            .onTapGesture {
                                teamNames[index] = randomNames.randomElement() ?? ""
                                viewModel.teams = teamNames
                            }
                            .foregroundStyle(Color.blue)
                        
                    }
                    .padding(.horizontal, 18)
                    .onLongPressGesture {
                        self.temporaryTeamName = self.teamNames[index]
                        self.editingTeamIndex = index
                        self.isAlertPresented = true
                    }
                }
                .onDelete(perform: removeTeam)
                .listRowBackground(Color.clear)
                CustomButton(name: "Add Team".localized) {
                    addTeam()
                }
                .padding()
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            Text("Press and hold to enter a team name".localized)
                .foregroundStyle(Color.blue)
            Text("Swipe to delete a team".localized)
                .foregroundStyle(Color.blue)
            CustomDisabledButton(name: "Next".localized, action: {
                isSetUpScreenActive = true
            }, isDisabled: teamNames.isEmpty)
        }
        .onAppear {
            viewModel.teams = teamNames
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .navigationDestination(isPresented: $isSetUpScreenActive) {
            SetUpScreen()
                .environmentObject(viewModel)
        }
        .alert("Team name".localized, isPresented: $isAlertPresented) {
            TextField("Enter Team Name".localized, text: $temporaryTeamName)
            Button("Save".localized) {
                if let editingIndex = editingTeamIndex {
                    teamNames[editingIndex] = temporaryTeamName
                    viewModel.teams = teamNames
                }
            }
            Button("Cancel".localized, role: .cancel) {}
        }
        .alert("Maximum number of teams reached!".localized, isPresented: $isWarningAlertPresented) {
            Button("Ok".localized, role: .cancel) {}
        }
    }
    private func addTeam() {
        if teamNames.count < 8 {
            let newTeamNumber = teamNames.count + 1
            teamNames.append("Team \(newTeamNumber)".localized)
            viewModel.teams = teamNames
        } else {
            isWarningAlertPresented = true
        }
    }
    
    private func removeTeam(at offsets: IndexSet) {
            teamNames.remove(atOffsets: offsets)
            viewModel.teams = teamNames
        }
}

#Preview {
    TeamName(timerDurations: [60])
}
