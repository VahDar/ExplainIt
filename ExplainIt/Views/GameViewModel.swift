//
//  GameViewModel.swift
//  ExplainIt
//
//  Created by Vakhtang on 04.01.2024.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var rootWord = ""
    var nextWord: [String] = []
    
    func loadWords(forTopic topicName: String) {
        print("Loading words for topic: \(topicName)")
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            print(startWordsURL)
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "manatee"
                return
            }
        }
       fatalError("Could not load start.txt from bundle")
    }
    
    func getNextWord() {
        
    }
}
