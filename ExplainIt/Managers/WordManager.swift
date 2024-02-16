//
//  WordManager.swift
//  ExplainIt
//
//  Created by Vakhtang on 15.02.2024.
//

import Foundation

class WordManager: ObservableObject {
    
    @Published var rootWord = ""
    @Published var currentTopic = ""
    @Published var swipedWords: [(word: String, swiped: Bool, isLastWord: Bool)] = []
    
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
    
    func clearSwipeWords() {
        swipedWords.removeAll()
    }
    
    func updateSwipe(word: String, swiped: Bool, isLast: Bool = false) {
        if let index = swipedWords.firstIndex(where: { $0.word == word }) {
            swipedWords[index].swiped = swiped
        } else {
            swipedWords.append((word, swiped, isLast))
        }
    }
}
