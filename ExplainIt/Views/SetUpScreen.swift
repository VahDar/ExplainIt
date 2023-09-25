//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    
    @State private var selectedDuration: TimeInterval = 60
    @State private var timerDurations = [30, 60, 90, 120]

    
    
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
                
                TimerView(timerDuration: selectedDuration)
                    .background(Color.clear)
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
