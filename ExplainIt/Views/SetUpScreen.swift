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
                CustomDivider()
                VStack {
                    HStack {
                        Text("Required Points:")
                            .foregroundStyle(Color.blue)
                        Picker("Required Points", selection: $selectedPoint) {
                            ForEach(requiredPoints, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.top, 40)
                }
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
                        ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(minimum: UIScreen.main.bounds.width - 36, maximum: UIScreen.main.bounds.width - 36))], spacing: 15) {
                            ForEach(topics, id: \.self) {
                                topic in
                                Button {
                                    selectedTopic = topic
                                    startGame(topicName: topic)
                                } label: {
                                    ZStack {
                                        Image(viewModel.backgroundImageName(for: topic))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 100)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        VStack {
                                            Spacer()
                                            Text(topic)
                                                .foregroundStyle(Color.white)
                                                .font(.headline)
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 2)
                                                )
                                                .background(Color.black.opacity(0.5))
                                            if selectedTopic == topic {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.green)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 100)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 40)
                    }
//                    .padding(.top, 40)
                }
                .frame(height: 300)
                .padding()
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
