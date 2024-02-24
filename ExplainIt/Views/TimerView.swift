//
//  TimerView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//

import SwiftUI
import UserNotifications
import AVFoundation


struct TimerView: View {
    @State private var to: CGFloat = 0
    @State private var count = 0
    @Binding var timerPaused: Bool
    @State private var isSoundPlayed = false
    @Binding var showPauseAnimation: Bool
    @Binding var isTimerRunning: Bool
    @EnvironmentObject var viewModel: GameViewModel
    var timerDuration: TimeInterval
    var onTimerEnd: () -> Void
    @State private var audioPlayer: AVAudioPlayer?
    @State private var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .trim(from: 0, to: self.to)
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 13, lineCap: .round))
                    .frame(width: 400, height: 300)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: .white, radius: 5, x: 0, y: 0)
                RoundedRectangle(cornerRadius: 20)
                    .trim(from: 0, to: self.to)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 12, lineCap: .round))
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
                        .foregroundColor(.black)
                        .shadow(color: .white, radius: 5, x: 0, y: 0)
                        .font(.largeTitle)
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
