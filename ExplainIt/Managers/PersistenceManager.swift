//
//  PersistenceManager.swift
//  ExplainIt
//
//  Created by Vakhtang on 15.02.2024.
//

import Foundation

class PersistenceManager: ObservableObject {
    
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

}
