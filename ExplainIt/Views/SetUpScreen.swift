//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    
    @State private var timerDurations = [30, 60, 90, 120]
    @Binding var selectedDuration: Int
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Round time")
                        .foregroundColor(.blue)
                    
                    Picker("Round Time", selection: $selectedDuration) {
                        ForEach(timerDurations, id: \.self) {
                            Text($0, format: .number)
                            
                        }
                    }
                    .pickerStyle(.menu)
                    .background(Color.clear)
                    
                }
                .padding(.trailing, 100)
                .padding(.top, -200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
        }
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    
    @State static var selectedDuration = 30
    
    static var previews: some View {
        SetUpScreen(selectedDuration: $selectedDuration)
    }
}
