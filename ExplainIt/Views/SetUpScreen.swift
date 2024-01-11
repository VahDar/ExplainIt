//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    @Binding var selectedDuration: Int
    @Binding var selectedPoint: Int
    @State private var teamName = ["Manatee"]
    @State private var timerDurations = [30, 60, 90, 120]
    @State private var points = [20, 30, 40, 50, 60, 70, 80]
    @State private var isButtonPressed = false
    @State private var selectedTopic: String?
    @State private var topics = ["start", "harryPotter"]
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Points:")
                        .foregroundStyle(Color.blue)
                        .padding(.leading, -160)
                    HStack {
                        Text("Required Points:")
                            .foregroundStyle(Color.blue)
                        Picker("Required Points", selection: $selectedPoint) {
                            ForEach(points, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.trailing, 120)
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
            
        }
    }
   
    func startGame(topicName: String) {
        viewModel.loadWords(forTopic: topicName)
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    @State static var selectedNumberOfTeams = 3
    @State static var selectedDuration = 30
    @State static var selectedPoint = 30
    static var previews: some View {
        SetUpScreen(selectedDuration: $selectedDuration, selectedPoint: $selectedPoint, viewModel: GameViewModel())
    }
}
