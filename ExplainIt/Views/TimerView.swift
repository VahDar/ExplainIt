////
////  TimerView.swift
////  ExplainIt
////
////  Created by Vakhtang on 07.09.2023.
////
//
//import SwiftUI
//import AVFoundation
//
//struct TimerView: View {
//    @State private var timerValue: CGFloat = 0.0
//    @Binding var isTimerRunning: Bool
//    @EnvironmentObject var viewModel: GameViewModel
//    var timerDuration: TimeInterval
//    var onTimerEnd: () -> Void
//    @State private var audioPlayer: AVAudioPlayer?
//    @State private var timer: Timer?
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 20)
//                    .trim(from: 0, to: timerValue)
//                    .stroke(Color(red: 79/255, green: 74/255, blue: 183/255), lineWidth: 10)
//                    .frame(width: 400, height: 300)
//                    .rotationEffect(.degrees(-90))
//                    .onAppear() {
//                        startTimer()
//                    }
//            }
//            .onAppear {
//                prepareAudioPlayer()
//            }
//        }
//    }
//            func startTimer() {
//                isTimerRunning = true
//                var isSoundPlayed = false
//                
//                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//                    
//                    if timerValue < 1.0 {
//                        withAnimation(.linear(duration: 1.0)) {
//                            timerValue += 1.0 / timerDuration
//                        }
//                        
//                        let timerLeft = timerDuration - (CGFloat(timerValue) * timerDuration)
//                        if viewModel.isSoundEnabled && timerLeft <= 5 && !isSoundPlayed {
//                            audioPlayer?.play()
//                            isSoundPlayed = true
//                        }
//                    } else {
//                        stopTimer()
//                        onTimerEnd()
//                    }
//                }
//                if let timer = timer {
//                    RunLoop.current.add(timer, forMode: .common)
//                }
//            }
//        
//    
//    private func prepareAudioPlayer() {
//        guard let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//            audioPlayer?.prepareToPlay()
//        } catch {
//            print("Error with download audio file")
//        }
//    }
//    
//    private func stopTimer() {
////        timer?.invalidate()
////        timer = nil
//        isTimerRunning = false
//        onTimerEnd()
//    }
//}
//
//
//
//struct TimerView_Previews: PreviewProvider {
//    @State static var isTimerRunning = true
//    @State static var isPaused = false
//    @State static var timerDuration = 30
//    static var previews: some View {
//        TimerView(isTimerRunning: $isTimerRunning, timerDuration: TimeInterval(timerDuration), onTimerEnd: {})
//    }
//}

import SwiftUI
import UserNotifications
import AVFoundation

// MARK: - ContentView.swift изменений не требуется, так как TimerView будет обновлен

// MARK: - GameViewModel.swift изменений не требуется, так как он уже включает необходимую логику

// MARK: - TimerView.swift
struct TimerView: View {
    @State private var to: CGFloat = 0
    @State private var count = 0
    @State private var timerPaused = false
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
                    .stroke(Color(red: 79/255, green: 74/255, blue: 183/255), lineWidth: 10)
                    .frame(width: 400, height: 300)
                    .rotationEffect(.degrees(-90))
            }
            .onAppear {
                prepareAudioPlayer()
            }
            .onReceive(self.time) { _ in
                var isSoundPlayed = false
                if self.isTimerRunning && !self.timerPaused {
                    if self.count < Int(self.timerDuration) {
                        self.count += 1
                        withAnimation(.linear(duration: 1.0)) {
                            self.to = CGFloat(self.count) / CGFloat(self.timerDuration)
                        }

                        let timerLeft = self.timerDuration - TimeInterval(self.count)
                        if self.viewModel.isSoundEnabled && timerLeft <= 5 && !isSoundPlayed {
                            self.audioPlayer?.play()
                            isSoundPlayed = true
                        }
                    } else {
                        self.isTimerRunning = false
                        self.onTimerEnd()
                    }
                }
            }

            Button(action: {
                self.timerPaused.toggle()
                if self.timerPaused {
                    self.isTimerRunning = false
                } else {
                    self.isTimerRunning = true
                }
            }) {
                Text(timerPaused ? "Продолжить" : "Пауза")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(width: 200)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding()
        }
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
