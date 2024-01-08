//
//  GameViewModel.swift
//  ExplainIt
//
//  Created by Vakhtang on 04.01.2024.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var rootWord = ""
    var currentTopic = ""
    
    func loadWords(forTopic topicName: String) {
       currentTopic = topicName
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
