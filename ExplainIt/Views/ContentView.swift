//
//  ContentView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct ContentView: View {

    
    @State private var isTeamScreenActive = false
    @State private var selectedDuration = 30
    @State private var numberOfTeams = 0
    @EnvironmentObject var viewModel: GameViewModel
    var timerDurations: [Int]
    
    init(selectedDuration: Int, timerDurations: [Int]) {
            self._selectedDuration = State(initialValue: selectedDuration)
            self.timerDurations = timerDurations
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                    CustomButton(name: "Continue") {
                        
                    }
                    .padding(.bottom)
                
                    CustomButton(name: "New game") {
                        isTeamScreenActive = true
                    }
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            
            .navigationDestination(isPresented: $isTeamScreenActive) {
                TeamName(selectedDuration: selectedDuration, timerDurations: timerDurations)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ContentView()
//    }
//}
