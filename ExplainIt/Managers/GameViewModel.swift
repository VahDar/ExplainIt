//
//  GameViewModel.swift
//  ExplainIt
//
//  Created by Vakhtang on 04.01.2024.
//

import Foundation
import UIKit

class GameViewModel: ObservableObject {
    
    // MARK: Published Properties
    @Published var rootWord = ""
    @Published var roundTime: Int = 30
    @Published var requiredPoints: Int = 20
    @Published var teams: [String] = []
    @Published var currentTeamIndex = 0
    @Published var teamPoints: [String: Int] = [:]
    @Published var teamRounds: [String: Int] = [:]
    @Published var swipedWords: [(word: String, swiped: Bool, isLastWord: Bool)] = []
    @Published var isGameScreenPresented: Bool = false
    @Published var isFinalRoundPhase: Bool = false
    @Published var isWinnerActive: Bool = false
    @Published var isSoundEnabled: Bool = true
    @Published var isGameStarted: Bool = false
    @Published var backgroundImagePath: String = ""
    @Published var winners: String = ""
    
    // MARK: Properties
     var currentTopic = ""
    
    // MARK: Initialization
    init() {
        setupNotifications()
    }
    
    // MARK: Public Methods
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
    
    func countWordsInFile(named fileName: String) -> Int {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else { return 0 }
        return content.components(separatedBy: "\n").filter { !$0.isEmpty }.count
    }
    
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
    
    // MARK: Private Methods
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.saveGameData()
        }
        
        notificationCenter.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.saveGameData()
        }
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

extension GameViewModel {
    
    // MARK: Data Persistence
    func saveGameData() {
        let encoder = JSONEncoder()
        if let encodedTeams = try? encoder.encode(teams),
           let encodedTeamPoints = try? encoder.encode(teamPoints),
           let encodedTeamRounds = try? encoder.encode(teamRounds),
           let encodedRoundTime = try? encoder.encode(roundTime),
           let encodedRequiredPoints = try? encoder.encode(requiredPoints)
        {
            UserDefaults.standard.set(encodedTeams, forKey: "teams")
            UserDefaults.standard.set(encodedTeamPoints, forKey: "teamPoints")
            UserDefaults.standard.set(encodedTeamRounds, forKey: "teamRounds")
            UserDefaults.standard.set(encodedRoundTime, forKey: "roundTime")
            UserDefaults.standard.set(encodedRequiredPoints, forKey: "requiredPoints")
        }
    }
    
    func loadGameData() {
        let decoder = JSONDecoder()
        if let teamsData = UserDefaults.standard.data(forKey: "teams"),
           let teamPointsData = UserDefaults.standard.data(forKey: "teamPoints"),
           let teamRoundsData = UserDefaults.standard.data(forKey: "teamRounds"),
           let roundTimeData = UserDefaults.standard.data(forKey: "roundTime"),
           let requiredPointsData = UserDefaults.standard.data(forKey: "requiredPoints"),
           let loadedTeams = try? decoder.decode([String].self, from: teamsData),
           let loadedTeamPoints = try? decoder.decode([String: Int].self, from: teamPointsData),
           let loadedTeamRounds = try? decoder.decode([String: Int].self, from: teamRoundsData),
           let loadedRoundTime = try? decoder.decode(Int.self, from: roundTimeData),
           let loadedRequiredPoints = try? decoder.decode(Int.self, from: requiredPointsData) {
            
            teams = loadedTeams
            teamPoints = loadedTeamPoints
            teamRounds = loadedTeamRounds
            roundTime = loadedRoundTime
            requiredPoints = loadedRequiredPoints
        }
    }
    
    func clearGameData() {
        UserDefaults.standard.removeObject(forKey: "teams")
        UserDefaults.standard.removeObject(forKey: "teamPoints")
        UserDefaults.standard.removeObject(forKey: "teamRounds")
        UserDefaults.standard.removeObject(forKey: "roundTime")
        UserDefaults.standard.removeObject(forKey: "requiredPoints")
    }
}
