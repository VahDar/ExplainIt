//
//  TimerView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//

import SwiftUI

struct TimerView: View {
    @State private var timerValue: CGFloat = 0.0
    @State private var isTimerRunning = false
    let timerDuration: TimeInterval = 10.0

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
            Text("\(Int(timerDuration - timerValue * timerDuration)) sec")
            
//            Button(action: {
//                if !isTimerRunning {
//                    startTimer()
//                } else {
//                    stopTimer()
//                }
//            }) {
//                Text(isTimerRunning ? "Пауза" : "Старт")
//            }
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
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    private func stopTimer() {
        isTimerRunning = false
    }
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
