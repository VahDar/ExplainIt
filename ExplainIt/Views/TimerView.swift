//
//  TimerView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//

import SwiftUI

struct TimerView: View {
//    @ObservedObject var gameSettings: GameSettings
     @State private var selectedDuration = 50
    @State private var isTimerRunning = false


    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .trim(from: 0, to: CGFloat(selectedDuration) / 10.0)
                    .stroke(Color(red: 79/255, green: 74/255, blue: 183/255), lineWidth: 10)
                    .frame(width: 400, height: 300)
                    .rotationEffect(.degrees(-90))
                    .onAppear() {
                        startTimer()
                    }
            }
            Text("\(selectedDuration) sec")
            
        }
    }

    func startTimer() {
        isTimerRunning = true
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if selectedDuration > 0 {
                withAnimation(.linear(duration: 1.0)) {
                    selectedDuration -= 1
                }
            } else {
                stopTimer()
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    private func stopTimer() {
        isTimerRunning = false
    }
}



//struct TimerView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        let gameSettings = GameSettings()
//        TimerView(gameSettings: gameSettings)
//    }
//}
