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
    @State private var randomName = ["Crazy cucumber", "Best", "Pony", "Just a winners"]
    
    init(selectedNumberOfTeams: Binding<Int>) {
        self._selectedNumberOfTeams = selectedNumberOfTeams
        self._teamNames = State(initialValue: Array(repeating: "", count: selectedNumberOfTeams.wrappedValue))
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TeamName_Previews: PreviewProvider {
    @State static var selectedNumberOfTeams = 3
    @State static var teamNames = ["Manatee"]
    static var previews: some View {
        TeamName(selectedNumberOfTeams: $selectedNumberOfTeams)
    }
}
//#Preview {
//    TeamName(selectedNumberOfTeams: .constant(3), teamNames: <#[String]#>)
//}
