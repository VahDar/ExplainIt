//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    @State var selectedDuration: Int = 30
    @State var selectedPoint: Int = 20
    @State private var teamName = ["Manatee"]
    @State private var timerDurations = [5, 30, 60, 90, 120]
    @State private var requiredPoints = [20, 30, 40, 50, 60, 70, 80]
    @State private var isButtonPressed = false
    @State private var isGameScreenActive = false
    @State private var selectedTopic: String?
    @State private var topics = ["start", "harryPotter"]
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Text("Required Points:")
                            .foregroundStyle(Color.blue)
                        Picker("Required Points", selection: $selectedDuration) {
                            ForEach(requiredPoints, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.top, 40)
                }
                CustomDivider()
                VStack {
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
                    .padding(.top, 40)
                }
                CustomDivider()
                VStack {
                    Text("Choose a Topic:")
                        .foregroundStyle(.blue)
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
                    .padding(.top, 40)
                }
                .padding(.top, 40)
                Spacer()
                CustomButton(name: "Next") {
                    isGameScreenActive = true
                }
                .padding()
            }
            .padding(.top, -240)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .navigationDestination(isPresented: $isGameScreenActive) {
                GameScreen()
                    .environmentObject(viewModel)
            }
        }
        
    }
    func startGame(topicName: String) {
        viewModel.loadWords(forTopic: topicName)
        viewModel.roundTime = selectedDuration
        viewModel.requiredPoints = selectedPoint
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SetUpScreen()
    }
}
