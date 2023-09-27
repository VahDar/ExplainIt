//
//  ExplainItApp.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

@main
struct ExplainItApp: App {
    var selectedDuration: Int = 0
    var timerDurations: [Int] = [5, 10, 15, 20]
    var body: some Scene {
        WindowGroup {
            ContentView(selectedDuration: selectedDuration, timerDurations: timerDurations)
        }
    }
}
