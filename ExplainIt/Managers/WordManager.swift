//
//  WordManager.swift
//  ExplainIt
//
//  Created by Vakhtang on 15.02.2024.
//

import Foundation

class WordManager: ObservableObject {
    
    @Published var swipedWords: [(word: String, swiped: Bool, isLastWord: Bool)] = []
    
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
