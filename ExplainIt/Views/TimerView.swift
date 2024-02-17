//
//  TimerView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//


import SwiftUI
import AVFoundation


struct TimerView: View {
    @State private var to: CGFloat = 0
    @State private var count = 0
    @Binding var timerPaused: Bool
    @State private var isSoundPlayed = false
    @Binding var showPauseAnimation: Bool
    @Binding var isTimerRunning: Bool
    var timerDuration: TimeInterval
    var onTimerEnd: () -> Void
    @State private var audioPlayer: AVAudioPlayer?
    @State private var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .trim(from: 0, to: self.to)
                    .stroke(Color(red: 79/255, green: 74/255, blue: 183/255), lineWidth: 10)
                    .frame(width: 400, height: 300)
                    .rotationEffect(.degrees(-90))
            }
            .onAppear {
                prepareAudioPlayer()
            }
            .onReceive(self.time) { _ in
                updateTimer()
            }

            if !timerPaused {
                Button(action: {
                    self.pauseTimer()
                }) {
                    Image(systemName: "pause.circle")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .clipShape(Circle())
                }
                .padding()
                .offset(x: -100, y: 100)
            }
        }
    }

    private func updateTimer() {
        if self.isTimerRunning && !self.timerPaused {
            if self.count < Int(self.timerDuration) {
                self.count += 1
                withAnimation(.linear(duration: 1.0)) {
                    self.to = CGFloat(self.count) / CGFloat(self.timerDuration)
                }

                let timerLeft = self.timerDuration - TimeInterval(self.count)
                if self.viewModel.isSoundEnabled && timerLeft <= 5 && !self.isSoundPlayed {
                    self.audioPlayer?.play()
                    self.isSoundPlayed = true
                }
            } else {
                self.isTimerRunning = false
                self.onTimerEnd()
            }
        }
    }

    private func pauseTimer() {
        showPauseAnimation = true
        timerPaused = true
        isTimerRunning = false
    }

    private func prepareAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error with audio file")
        }
    }
}
