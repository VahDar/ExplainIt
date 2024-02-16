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
    
    func backgroundImageName(for topic: String) -> String {
        return UIImage(named: topic) != nil ? topic : "defaultBackground"
    }
    
    func resetGame() {
        rootWord = ""
        roundTime = 30
        requiredPoints = 20
        teams = []
        currentTeamIndex = 0
        teamPoints = [:]
        teamRounds = [:]
        swipedWords = []
        isGameScreenPresented = false
        isFinalRoundPhase = false
        isWinnerActive = false
        isGameStarted = false
        backgroundImagePath = ""
        winners = ""
        currentTopic = ""
    }
}
