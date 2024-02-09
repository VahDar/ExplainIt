import SwiftUI

struct GameScreen: View {
    @State private var language = LocalizationService.shared.language
    @State private var isViewVisible = false
    @State private var isTimerEnd = false
    @State private var isTimerRunning = false
    @State private var timerEnded = false
    @State private var lastWordSwiped = false
    @State private var timerView: TimerView?
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Need Fix bug with random words when start a new round
                VStack {
                    if !isViewVisible {
                        VStack {
                            Text("Now play %@".localized(language, args: viewModel.teams[viewModel.currentTeamIndex]))
                                .foregroundStyle(Color.blue)
                                .padding()
                            Text("If you guessed the word swipe up, if not, swipe down.".localized(language))
                                .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                .multilineTextAlignment(.center)
                            
                            CustomButton(name: "Start".localized(language)) {
                                startRound()
                                viewModel.clearSwipeWords()
                            }
                        }
                    }
                    if isViewVisible {
                        ZStack {
                            TimerView(isTimerRunning: $isTimerRunning, timerDuration: TimeInterval(viewModel.roundTime), onTimerEnd: {
                                timerEnded = true
                                if !lastWordSwiped {
                                    viewModel.updateSwipe(word: viewModel.rootWord, swiped: false, isLast: true)
                                    isTimerEnd = true
                                }
                            })
                            .environmentObject(viewModel)
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
                                    let swiped = swipeDistance < 0
                                    lastWordSwiped = true
                                    
                                    if timerEnded {
                                        viewModel.updateSwipe(word: viewModel.rootWord, swiped: swiped, isLast: true)
                                        isTimerEnd = true
                                    } else {
                                        viewModel.updateSwipe(word: viewModel.rootWord, swiped: swiped)
                                        viewModel.loadWords(forTopic: viewModel.currentTopic)
                                    }
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
                    CustomAlertView(wordSwipeData: $viewModel.swipedWords,points: .constant(3))
                        .environmentObject(viewModel)
                        .frame(width: 300, height: 500)
                        .background(BackgroundView())
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 10)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                        )
                }
            }
        }
    }
    
    func startRound() {
        isViewVisible = true
        isTimerRunning = true
    }
}

//struct GameScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        GameScreen()
//    }
//}
