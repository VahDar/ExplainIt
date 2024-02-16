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
    @Published var requiredPoints: Int = 20
    @Published var isSoundEnabled: Bool = true
    @Published var backgroundImagePath: String = ""
    @Published var isGameStarted: Bool = false
    
    let teamsManager: TeamsManager
    let wordsManager: WordsManager
    
    init(teamsManager: TeamsManager, wordsManager: WordsManager) {
        self.teamsManager = teamsManager
        self.wordsManager = wordsManager
    }
    
    func backgroundImageName(for topic: String) -> String {
        return UIImage(named: topic) != nil ? topic : "defaultBackground"
    }
    
    func resetGame() {
        wordsManager.rootWord = ""
        roundTime = 30
        requiredPoints = 20
        teamsManager.teams = []
        teamsManager.currentTeamIndex = 0
        teamsManager.teamPoints = [:]
        teamsManager.teamRounds = [:]
        wordsManager.swipedWords = []
        teamsManager.isGameScreenPresented = false
        teamsManager.isFinalRoundPhase = false
        teamsManager.isWinnerActive = false
        isGameStarted = false
        backgroundImagePath = ""
        teamsManager.winners = ""
        wordsManager.currentTopic = ""
    }
}
