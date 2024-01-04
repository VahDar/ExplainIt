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
                
                HStack {
                    Text("Choose a Topic:")
                        .foregroundStyle(.blue)
                        .padding(.trailing, 195)
                }
                .padding()
            }
            .padding(.top, -240)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            
        }
    }
    
    func startGame(topicName: String) {
        @State var rootWord = ""
        if let startWordsURL = Bundle.main.url(forResource: topicName, withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "manatee"
                return
            }
        }
       fatalError("Could not load start.txt from bundle")
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    
    @State static var selectedDuration = 30
    
    static var previews: some View {
        SetUpScreen(selectedDuration: $selectedDuration)
    }
}
