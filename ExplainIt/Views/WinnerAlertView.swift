//
//  WinnerAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 23.01.2024.
//

import SwiftUI

struct WinnerAlertView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var selectedDuration = 30
    @State private var timerDuration = [30]
    @State private var isGameFinish: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Group {
                Text("Winner: ").font(.title2)
                + Text("\(viewModel.winners)")
                    .font(.title)
            }
            .foregroundStyle(Color.blue)
            .padding()
            .offset(y: -140)
            SettingAnimationView(animationFileName: "astronaut", loopMode: .loop)
                .frame(width: 100, height: 100)
                .scaleEffect(0.2)
                .padding()
            VStack {
                Spacer()
                CustomButton(name: "Finish") {
                    isGameFinish = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .navigationDestination(isPresented: $isGameFinish) {
            ContentView(selectedDuration: selectedDuration, timerDurations: timerDuration)
        }
    }
}

#Preview {
    WinnerAlertView()
}
