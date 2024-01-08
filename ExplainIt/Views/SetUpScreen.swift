//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    @State private var timerDurations = [30, 60, 90, 120]
    @Binding var selectedDuration: Int
    @State private var numberOfTeams = [2, 4, 6]
    @Binding var selectedNumberOfTeams: Int
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
//                    Button {
//                        if isButtonPressed {
//                            isButtonPressed = false
//                        } else {
//                            isButtonPressed = true
//                            startGame(topicName: "start")
//                        }
//                    } label: {
//                        Text("General topic")
//                            .foregroundStyle(isButtonPressed ? Color.white : Color.white)
//                            .padding()
//                            .background(isButtonPressed ? Color.purple : Color.blue)
//                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
//                    }
                    .padding()
                    .padding(.trailing, 160)
                }
                .padding()
            }
            .padding(.top, -240)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            
        }
    }
   
    func startGame(topicName: String) {
        viewModel.loadWords(forTopic: topicName)
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    @State static var selectedNumberOfTeams = 2
    @State static var selectedDuration = 30
    static var previews: some View {
        SetUpScreen(selectedDuration: $selectedDuration, selectedNumberOfTeams: $selectedNumberOfTeams, viewModel: GameViewModel())
    }
}
