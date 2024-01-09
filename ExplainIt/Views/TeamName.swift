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
    
    init(selectedNumberOfTeams: Binding<Int>) {
        self._selectedNumberOfTeams = selectedNumberOfTeams
        self._teamNames = State(initialValue: Array(repeating: "", count: selectedNumberOfTeams.wrappedValue))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<selectedNumberOfTeams, id: \.self) { index in
                    HStack {
                        TextField("Team \(index + 1) Name", text: $teamNames[index])
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundStyle(.white)
                            
                        Button("Random name") {
                            teamNames[index] = randomNames.randomElement() ?? ""
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
    }
}

#Preview {
    TeamName(selectedNumberOfTeams: .constant(3))
}
