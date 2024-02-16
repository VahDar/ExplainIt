//
//  GameSessionManager.swift
//  ExplainIt
//
//  Created by Vakhtang on 16.02.2024.
//

import Foundation
import UIKit

class GameSettingsManager: ObservableObject {
    
    @Published var roundTime: Int = 30
//    @Published var requiredPoints: Int = 20
    @Published var isSoundEnabled: Bool = true
    @Published var backgroundImagePath: String = ""
    @Published var isGameStarted: Bool = false
    
    let wordsAndTeamsManager: WordsAndTeamsManager
//    let wordsManager: WordsManager
    
    init(wordsAndTeamsManager: WordsAndTeamsManager) {
        self.wordsAndTeamsManager = wordsAndTeamsManager
    }
    
    func backgroundImageName(for topic: String) -> String {
        return UIImage(named: topic) != nil ? topic : "defaultBackground"
    }
    
    func resetGame() {
        wordsAndTeamsManager.rootWord = ""
        roundTime = 30
        wordsAndTeamsManager.requiredPoints = 20
        wordsAndTeamsManager.teams = []
        wordsAndTeamsManager.currentTeamIndex = 0
        wordsAndTeamsManager.teamPoints = [:]
        wordsAndTeamsManager.teamRounds = [:]
        wordsAndTeamsManager.swipedWords = []
        wordsAndTeamsManager.isGameScreenPresented = false
        wordsAndTeamsManager.isFinalRoundPhase = false
        wordsAndTeamsManager.isWinnerActive = false
        isGameStarted = false
        backgroundImagePath = ""
        wordsAndTeamsManager.winners = ""
        wordsAndTeamsManager.currentTopic = ""
    }
}
