//
//  GameViewModel.swift
//  ExplainIt
//
//  Created by Vakhtang on 04.01.2024.
//

import Foundation
import UIKit

class GameViewModel: ObservableObject {
    @Published var rootWord = ""
    @Published var roundTime: Int = 30
    @Published var selectedDuration: Int = 30
    @Published var selectedPoint: Int = 20
    @Published var requiredPoints: Int = 20
    @Published var teams: [String] = []
    @Published var currentTeamIndex = 0
    @Published var teamPoints: [String: Int] = [:]
    @Published var teamRounds: [String: Int] = [:]
    @Published var swipedWords: [(word: String, swiped: Bool)] = []
    @Published var isGameScreenPresented: Bool = false
    @Published var isFinalRoundPhase: Bool = false
    @Published var isWinnerActive: Bool = false
    @Published var backgroundImagePath: String = "defult"
    @Published var winners: String = ""
    var currentTopic = ""
    
    
    
    func moveToNextTeam() {
        // If game in fase extra round
        if isFinalRoundPhase {
            if let nextTeamIndex = findNextTeamForExtraRound() {
                currentTeamIndex = nextTeamIndex
            } else {
                // If all teams played equil number of rounds
                isFinalRoundPhase = false
                return
            }
        } else {
            // next team step
            currentTeamIndex = (currentTeamIndex + 1) % teams.count
        }
        isGameScreenPresented = false
        isGameScreenPresented = true
        
        // Increase the round counter for the current team
        let currentTeam = teams[currentTeamIndex]
        teamRounds[currentTeam, default: 0] += 1
        
        if !isFinalRoundPhase && currentTeamIndex == 0 {
            checkForGameEnd()
        }
    }
    
    func updateTeamPoints(team: String, points: Int) {
        if let existingPoints = teamPoints[team] {
            teamPoints[team] = existingPoints + points
        } else {
            teamPoints[team] = points
        }
    }
    
    private func findNextTeamForExtraRound() -> Int? {
        let maxRoundsPlayed = teamRounds.values.max() ?? 0
        let minRoundsPlayed = teamRounds.values.min() ?? 0
        
        //If not needed extra round return nil
        if maxRoundsPlayed == minRoundsPlayed {
            isFinalRoundPhase = false
            return nil
        }
        
        // Serching a team with min value of rounds
        for (index, team) in teams.enumerated() {
            if let roundsPlayed = teamRounds[team], roundsPlayed < maxRoundsPlayed {
                return index
            }
        }
        return nil
    }
    
    private func checkForGameEnd() {
        let maxRoundPlayed = teamRounds.values.max() ?? 0
        let potentialWinners = teamPoints.filter { $0.value >= requiredPoints }
        
        if !potentialWinners.isEmpty {
            let teamsNoodingExtraRounds = teamRounds.filter { $1 < maxRoundPlayed }
            if teamsNoodingExtraRounds.isEmpty {
                // All teams have played an equal number of rounds, the winner can be declared
                let winner = potentialWinners.max(by: { $0.value < $1.value })
                print("Team winner is: \(winner?.key ?? "no winner") with \(winner?.value ?? 0) points!")
                winners = winner?.key ?? "no winner"
                isWinnerActive = true
                isFinalRoundPhase = false
            } else {
                isFinalRoundPhase = true
                print("Additional rounds required for some teams")
            }
        }
    }
    
    func clearSwipeWords() {
        swipedWords.removeAll()
    }
    
    func updateSwipe(word: String, swiped: Bool) {
        if let index = swipedWords.firstIndex(where: { $0.word == word }) {
            swipedWords[index].swiped = swiped
        } else {
            swipedWords.append((word, swiped))
        }
    }
    
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
    
    func backgroundImageName(for topic: String) -> String {
            return UIImage(named: topic) != nil ? topic : "defaultBackground"
        }
}
