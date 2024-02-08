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
    @State private var requiredPoints = [5, 20, 30, 40, 50, 60, 70, 80]
    @State private var isButtonPressed = false
    @State private var isGameScreenActive = false
    @State private var selectedTopic: String?
    @State private var topics = ["General", "Harry Potter"]
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                CustomDivider()
                    .offset(y: 30)
                    HStack {
                        Text("Required Points:".localized)
                            .foregroundStyle(Color.blue)
                        Picker("Required Points".localized, selection: $selectedPoint) {
                            ForEach(requiredPoints, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.top, 40)
                
                    HStack {
                        Text("Round Time:".localized)
                            .foregroundStyle(.blue)
                        
                        Picker("Round Time".localized, selection: $selectedDuration) {
                            ForEach(timerDurations, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.top, 40)
                Toggle("Turn on/off timer sound: ".localized, isOn: $viewModel.isSoundEnabled)
                    .tint(.blue)
                    .foregroundStyle(Color.blue)
                    .padding(.horizontal, 80)
                    .padding(.top, 40)
                CustomDivider()
                
                    VStack {
                        Text("Choose a Topic:".localized)
                            .foregroundStyle(.blue)
                        ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(minimum: UIScreen.main.bounds.width - 36, maximum: UIScreen.main.bounds.width - 36))], spacing: 15) {
                            ForEach(topics, id: \.self) {
                                topic in
                                Button {
                                    selectedTopic = topic
                                } label: {
                                    ZStack {
                                        Image(viewModel.backgroundImageName(for: topic))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 100)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .opacity(0.5)
                                        VStack {
                                            Spacer()
                                            Text(topic)
                                                .foregroundStyle(Color.blue)
                                                .font(.headline)
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(selectedTopic == topic ? Color(red: 79/255, green: 74/255, blue: 183/255) : Color.black, lineWidth: 2)
                                                )
                                                .background(selectedTopic == topic ? Color(red: 79/255, green: 74/255, blue: 183/255) : Color.black.opacity(0.5))
                                        }
                                    }
                                }
                                .frame(height: 100)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 40)
                    }
                }
                .frame(height: 300)
                .padding()
                CustomDisabledButton(name: "Next".localized, action: {
                    startGame()
                    isGameScreenActive = true
                }, isDisabled: selectedTopic == nil)
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
    func startGame() {
        viewModel.currentTopic = selectedTopic ?? "General"
        viewModel.roundTime = selectedDuration
        viewModel.requiredPoints = selectedPoint
        viewModel.loadWords(forTopic: viewModel.currentTopic)
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SetUpScreen()
    }
}
