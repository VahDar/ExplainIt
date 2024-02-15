//
//  TeamManager.swift
//  ExplainIt
//
//  Created by Vakhtang on 15.02.2024.
//

import Foundation

class TeamManager: ObservableObject {
    
    @Published var teams: [String] = []
    @Published var currentTeamIndex = 0
    @Published var teamPoints: [String: Int] = [:]
    @Published var teamRounds: [String: Int] = [:]
    
    func moveToNextTeam() {
        print("Index Team: - \(currentTeamIndex)")
        let wasLastTeam = currentTeamIndex == teams.count - 1
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
        loadWords(forTopic: currentTopic)
        isGameScreenPresented = true
        
        // Increase the round counter for the current team
        let currentTeam = teams[currentTeamIndex]
        teamRounds[currentTeam, default: 0] += 1
        
        if !isFinalRoundPhase && wasLastTeam {
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
}
