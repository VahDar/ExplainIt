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
    @State private var isButtonPressed = false
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        NavigationStack {
            VStack {
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
                    Button {
                        if isButtonPressed {
                            isButtonPressed = false
                        } else {
                            isButtonPressed = true
                            startGame(topicName: "start")
                        }
                    } label: {
                        Text("General topic")
                            .foregroundStyle(isButtonPressed ? Color.white : Color.white)
                            .padding()
                            .background(isButtonPressed ? Color.blue : Color.purple)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    }
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
    
    @State static var selectedDuration = 30
    static var previews: some View {
        SetUpScreen(selectedDuration: $selectedDuration, viewModel: GameViewModel())
    }
}
