//
//  TimerView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//

import SwiftUI
import AVFoundation

struct TimerView: View {
    @State private var timerValue: CGFloat = 0.0
    @Binding var isTimerRunning: Bool
    @Binding var isPaused: Bool
    @EnvironmentObject var viewModel: GameViewModel
    var timerDuration: TimeInterval
    var onTimerEnd: () -> Void
    @State private var audioPlayer: AVAudioPlayer?
    @State private var timer: Timer?
    
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
        }
        .onAppear {
            prepareAudioPlayer()
        }
        .onChange(of: isPaused) { newValue in
            if !newValue {
                if isTimerRunning {
                    startTimer()
                }
            } else {
                pauseTimer()
            }
        }
    }
    
    func startTimer() {
        guard !isPaused else {return}
        isTimerRunning = true
        var isSoundPlayed = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            if timerValue < 1.0 {
                withAnimation(.linear(duration: 1.0)) {
                    timerValue += 1.0 / timerDuration
                }
                
                let timerLeft = timerDuration - (CGFloat(timerValue) * timerDuration)
                if viewModel.isSoundEnabled && timerLeft <= 5 && !isSoundPlayed {
                    audioPlayer?.play()
                    isSoundPlayed = true
                }
            } else {
                stopTimer()
                onTimerEnd()
            }
        }
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    private func prepareAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error with download audio file")
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        onTimerEnd()
    }
}



struct TimerView_Previews: PreviewProvider {
    @State static var isTimerRunning = true
    @State static var isPaused = false
    @State static var timerDuration = 30
    static var previews: some View {
        TimerView(isTimerRunning: $isTimerRunning, isPaused: $isPaused, timerDuration: TimeInterval(timerDuration), onTimerEnd: {})
    }
}
