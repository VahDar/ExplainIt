import SwiftUI

struct GameScreen: View {
    @State private var isViewVisible = false
    @State private var isTimerEnd = false
    @State private var isTimerRunning = false
    @State private var timerView: TimerView?
    @State private var points = 0
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if !isViewVisible {
                        VStack {
                            Text("Now play \(viewModel.teams[viewModel.currentTeamIndex]) team")
                                .foregroundStyle(Color.blue)
                                .padding()
                            Text("If you guessed the word swipe up, if not, swipe down.")
                                .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                            
                            CustomButton(name: "Start") {
                                startRound()
                            }
                        }
                    }
                    if isViewVisible {
                        ZStack {
                            VStack {
                                Text("\(points)")
                            }
                            .foregroundStyle(Color.blue)
                            .padding(.top, -300)
                            TimerView(isTimerRunning: $isTimerRunning, timerDuration: TimeInterval(viewModel.roundTime), onTimerEnd: {
                                isTimerEnd = true
                            })
                            Text(viewModel.rootWord)
                                .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .frame(width: 300, height: 300)
                                .contentShape(Rectangle())
                        }
                        .gesture(
                            DragGesture()
                                .onEnded({ gesture in
                                    let swipeDistance = gesture.translation.height
                                    if swipeDistance < 0 {
                                        points += 1
                                    } else if swipeDistance > 0 {
                                        points -= 1
                                    }
                                    viewModel.loadWords(forTopic: viewModel.currentTopic)
                                })
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    BackgroundView()
                        .blur(radius: isTimerEnd ? 10 : 0)
                )
                .blur(radius: isTimerEnd ? 10 : 0)
                if isTimerEnd {
                    CustomAlertView()
                        .frame(width: 300, height: 500)
                        .background(BackgroundView())
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 10)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                        )
                }
            }
            .onAppear {
                prepareForRound()
            }
        }
    }
    
    func prepareForRound() {
        viewModel.currentTeamIndex = (viewModel.currentTeamIndex + 1) % viewModel.teams.count
    }
    
    func startRound() {
        isViewVisible = true
        isTimerRunning = true
        points = 0
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
