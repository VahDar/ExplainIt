//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    
    @State private var timerDurations = [30, 60, 90, 120]
    @State private var selectedDuration = 0
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Round Time", selection: $selectedDuration) {
                    ForEach(timerDurations, id: \.self) {
                        Text($0, format: .number)
                    }
                }
                .pickerStyle(.menu)
                .background(Color.clear)
                
                
                TimerView(selectedDuration: $selectedDuration, timerDurations: timerDurations)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
        }
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SetUpScreen()
    }
}
