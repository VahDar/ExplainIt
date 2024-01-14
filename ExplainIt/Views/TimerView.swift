//
//  TimerView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//

import SwiftUI

struct TimerView: View {
    @State private var timerValue: CGFloat = 0.0
    @Binding var isTimerRunning: Bool
    var timerDuration: TimeInterval
    var onTimerEnd: () -> Void
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .trim(from: 0, to: timerValue)
                    .stroke(Color(red: 79/255, green: 74/255, blue: 183/255), lineWidth: 10)
                    .frame(width: 400, height: 300)
                    .rotationEffect(.degrees(-90))
                    .onAppear() {
                        startTimer()
                    }
            }
            Text("\(Int(timerDuration > 0 ? timerDuration - timerValue * timerDuration : 60)) sec")
                .foregroundColor(.white)
            
        }
    }

     func startTimer() {
        isTimerRunning = true
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timerValue < 1.0 {
                withAnimation(.linear(duration: 1.0)) {
                    timerValue += 1.0 / timerDuration
                }
            } else {
                stopTimer()
                onTimerEnd()
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    private func stopTimer() {
        isTimerRunning = false
        onTimerEnd()
    }
}



struct TimerView_Previews: PreviewProvider {
    @State static var isTimerRunning = true
    @State static var timerDuration = 30
    static var previews: some View {
        TimerView(isTimerRunning: $isTimerRunning, timerDuration: TimeInterval(timerDuration), onTimerEnd: {})
    }
}
