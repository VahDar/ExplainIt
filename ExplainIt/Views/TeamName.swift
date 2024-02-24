//
//  TeamName.swift
//  ExplainIt
//
//  Created by Vakhtang on 08.01.2024.
//

import SwiftUI

struct TeamName: View {
    
    // MARK: - Properties
    @State private var teamNames: [String] = []
    @State private var language = LocalizationService.shared.language
    
    @State private var isSetUpScreenActive = false
    @State private var isAlertPresented = false
    @State private var isWarningAlertPresented = false
    @State private var temporaryTeamName = ""
    @State private var editingTeamIndex: Int?
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    var timerDurations: [Int]
    var randomNames: [String] { LocalizationService.shared.language == .ukrainian ? ["Божевільні Огіроки", "Найкращі", "Поні", "Переможці", "Ламантин", "Сосиски", "Самураї", "Легенди", "Шахраї", "Єдинороги", "Герії", "Тролі"] : ["Crazy cucumbers", "Best", "Pony", "Just winners", "Manatee", "Souseges", "Samurai", "Legends", "Cheaters", "Unicorns", "Geniuses", "Trolls"]
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            teamList
            instructionsView
            navigationButton
        }
        .onAppear {
            viewModel.teams = teamNames
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .alert("Team name".localized(language), isPresented: $isAlertPresented) {
            TextField("Enter Team Name".localized(language), text: $temporaryTeamName)
            Button("Save".localized(language)) {
                if let editingIndex = editingTeamIndex {
                    teamNames[editingIndex] = temporaryTeamName
                    viewModel.teams = teamNames
                }
            }
            Button("Cancel".localized(language), role: .cancel) {}
        }
        .alert("Maximum number of teams reached!".localized(language), isPresented: $isWarningAlertPresented) {
            Button("OK".localized(language), role: .cancel) {}
        }
        
        // Conditional navigation
        .navigationDestination(isPresented: $isSetUpScreenActive) {
                        SetUpScreen()
                .environmentObject(viewModel)
                .navigationBarBackButtonHidden(true)
         }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .navigationBarItems(leading: Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack{
                Image(systemName: "chevron.left")
                Text("Main")
            }
        })
    }

    // MARK: - View Components

    private var teamList: some View {
        List {
            ForEach(0..<teamNames.count, id: \.self) { index in
                HStack {
                    TextField("Team \(index + 1) Name".localized(language), text: $teamNames[index])
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundStyle(.white)
                    Spacer()
                    Text("Random".localized(language))
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
            CustomButton(name: "Add Team".localized(language)) {
                addTeam()
            }
            .padding()
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
    }

    private var instructionsView: some View {
        VStack {
            Text("Press and hold to enter a team name".localized(language))
                .foregroundStyle(Color.blue)
                .multilineTextAlignment(.center)
            Text("Swipe to delete a team".localized(language))
                .foregroundStyle(Color.blue)
                .multilineTextAlignment(.center)
        }
    }

    private var navigationButton: some View {
        CustomDisabledButton(name: "Next".localized(language), action: {
            isSetUpScreenActive = true
        }, isDisabled: teamNames.isEmpty)
    }

    // MARK: - Methods

    private func addTeam() {
        if teamNames.count < 8 {
            teamNames.append("Team \(teamNames.count + 1)")
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
