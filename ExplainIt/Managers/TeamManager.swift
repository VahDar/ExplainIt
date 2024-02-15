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
    @Published var isFinalRoundPhase: Bool = false
    @Published var winners: String = ""
    
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
    
    private func checkForGameEnd() {
        let teamsNeedingExtraRounds = teamPoints.filter { $0.value >= requiredPoints }
        
        let potentialWinners = teamPoints.filter { $0.value >= requiredPoints }
        
        // If there are teams that have not played as many rounds as the team(s) with the maximum rounds played,
        // set the game to enter the final round phase for these teams to catch up.
        if teamsNeedingExtraRounds.isEmpty {
            isFinalRoundPhase = true
            print("Additional rounds required for some teams.")
        }
        
        // If all teams have played the same number of rounds, check for winners.
        if !potentialWinners.isEmpty {
            // Identify the team with the highest points as the winner.
            // This accounts for the scenario where multiple teams may have reached the required points.
            let winner = potentialWinners.max(by: { $0.value < $1.value })
            winners = winner?.key ?? "not winner"
            isWinnerActive = true
            isFinalRoundPhase = false
            print("Winner is: \(winners) with \(winner?.value ?? 0) points!")
        } else {
            // If no team has reached the required points, the game can continue, or you may implement other logic to handle this scenario.
            print("No winners yet. Game continues or another end game logic applies.")
        }
    }
    
}
