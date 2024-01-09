//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    @Binding var selectedNumberOfTeams: Int
    @Binding var selectedDuration: Int
    @State private var teamName = ["Manatee"]
    @State private var timerDurations = [30, 60, 90, 120]
    @State private var numberOfTeams = [0, 2, 3, 4, 5, 6]
    @State private var showSheet = false
    @State private var isButtonPressed = false
    @State private var selectedTopic: String?
    @State private var topics = ["start", "harryPotter"]
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Teams:")
                        .foregroundStyle(.blue)
                        .padding(.leading, -160)
                    
                    HStack {
                        Text("Number of teams:")
                            .foregroundStyle(.blue)
                        
                        Picker("Number of teams", selection: $selectedNumberOfTeams) {
                            ForEach(numberOfTeams, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .onChange(of: selectedNumberOfTeams) {
                            newValue in
                            showSheet = true
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.trailing, 95)
                }
                .padding()
                VStack {
                    Text("Timer:")
                        .foregroundStyle(.blue)
                        .padding(.leading, -160)
                    HStack {
                        Text("Round time:")
                            .foregroundStyle(.blue)
                        
                        Picker("Round Time", selection: $selectedDuration) {
                            ForEach(timerDurations, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.trailing, 120)
                }
                
                VStack {
                    Text("Choose a Topic:")
                        .foregroundStyle(.blue)
                        .padding(.trailing, 195)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 100))]) {
                        ForEach(topics, id: \.self) {
                            topic in
                            Button {
                                selectedTopic = topic
                                startGame(topicName: topic)
                            } label: {
                                Text(topic)
                                if selectedTopic == topic {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
                .padding()
            }
            .padding(.top, -240)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .sheet(isPresented: $showSheet, content: {
                TeamName(selectedNumberOfTeams: $selectedNumberOfTeams)
            })
        }
    }
   
    func startGame(topicName: String) {
        viewModel.loadWords(forTopic: topicName)
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    @State static var selectedNumberOfTeams = 3
    @State static var selectedDuration = 30
    static var previews: some View {
        SetUpScreen(selectedNumberOfTeams: $selectedNumberOfTeams, selectedDuration: $selectedDuration, viewModel: GameViewModel())
    }
}
