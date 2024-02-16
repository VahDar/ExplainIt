//
//  ExplainItApp.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

@main
struct ExplainItApp: App {
    var selectedDuration: Int = 60
    var timerDurations: [Int] = [30, 60, 90, 120]
    var wordsAndTeamsManager = WordsAndTeamsManager()
    let settingsManager: GameSettingsManager
    let persistenceManager: PersistenceManager
    
    init() {
        wordsAndTeamsManager = WordsAndTeamsManager()
        settingsManager = GameSettingsManager(wordsAndTeamsManager: wordsAndTeamsManager)
        persistenceManager = PersistenceManager(teamManager: wordsAndTeamsManager, settingsManager: settingsManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(selectedDuration: selectedDuration, timerDurations: timerDurations)
                .environmentObject(wordsAndTeamsManager)
                .environmentObject(settingsManager)
                .environmentObject(persistenceManager)
        }
    }
}
