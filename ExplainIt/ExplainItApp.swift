//
//  ExplainItApp.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

@main
struct ExplainItApp: App {
    @StateObject var viewModel = GameViewModel()
    var selectedDuration: Int = 60
    var timerDurations: [Int] = [30, 60, 90, 120]
    var body: some Scene {
        WindowGroup {
            ContentView(selectedDuration: selectedDuration, timerDurations: timerDurations)
                .environmentObject(viewModel)
        }
    }
}
