//
//  TeamName.swift
//  ExplainIt
//
//  Created by Vakhtang on 08.01.2024.
//

import SwiftUI

struct TeamName: View {
    @Binding var selectedNumberOfTeams: Int
    @State var teamNames: [String]
    @State private var randomNames = ["Crazy cucumber", "Best", "Pony", "Just a winners", "Manatee"]
    @State private var isSetUpScreenActive = false
    init(selectedNumberOfTeams: Binding<Int>) {
        self._selectedNumberOfTeams = selectedNumberOfTeams
        self._teamNames = State(initialValue: Array(repeating: "", count: 2))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<teamNames.count, id: \.self) { index in
                    HStack {
                        TextField("Team \(index + 1) Name", text: $teamNames[index])
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundStyle(.white)
                        Spacer()
                        Button("Random") {
                            teamNames[index] = randomNames.randomElement() ?? ""
                        }
                        .frame(width: 80, height: 40)
                        
                    }
                    .padding(.horizontal, 18)
                }
                .onDelete(perform: removeTeam(at:) )
                .listRowBackground(Color.clear)
                CustomButton(name: "Add Team") {
                    addTeam()
                }
                .padding()
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            CustomButton(name: "Next") {
                isSetUpScreenActive = true
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
    }
    private func addTeam() {
        teamNames.append("")
    }
    
    private func removeTeam(at offsets: IndexSet) {
            teamNames.remove(atOffsets: offsets)
        }
}

#Preview {
    TeamName(selectedNumberOfTeams: .constant(3))
}
