import SwiftUI

struct GameScreen: View {
    @State private var language = LocalizationService.shared.language
    @State private var isViewVisible = false
    @State private var isTimerEnd = false
    @State private var timerPaused = false
    @State private var isTimerRunning = false
    @State private var timerEnded = false
    @State private var lastWordSwiped = false
    @State private var showPauseAnimation = false
    @State private var wordOffset = CGSize.zero
    @State private var wordOpacity = 1.0
    @State private var timerView: TimerView?
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if !isViewVisible {
                        VStack {
                            Text("Now play %@".localized(language, args: viewModel.teams[viewModel.currentTeamIndex]))
                                .foregroundStyle(Color.blue)
                                .padding()
                            Text("If you guessed the word swipe up, if not, swipe down.".localized(language))
                                .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                                .font(.system(size: 36))
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
                            TimerView(timerPaused: $timerPaused, showPauseAnimation: $showPauseAnimation, isTimerRunning: $isTimerRunning, timerDuration: TimeInterval(viewModel.roundTime), onTimerEnd: {
                                timerEnded = true
                                if !lastWordSwiped {
                                    viewModel.updateSwipe(word: viewModel.rootWord, swiped: false, isLast: true)
                                    isTimerEnd = true
                                }
                            })
                            .environmentObject(viewModel)
                            .overlay(
                            Text(viewModel.rootWord)
                                .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .frame(width: 300, height: 300)
                                .multilineTextAlignment(.center)
                                .contentShape(Rectangle())
                                .offset(wordOffset)
                                .opacity(wordOpacity)
                                .offset(y: -30)
                            , alignment: .center
                            )
                        }
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    wordOffset = gesture.translation
                                })
                                .onEnded({ gesture in
                                    let swipeDistance = gesture.translation.height
                                    let swipedUp = swipeDistance < 0
                                    lastWordSwiped = true
                                    
                                    withAnimation(.easeIn(duration: 0.3)) {
                                        self.wordOffset = CGSize(width: 0, height: swipedUp ? -200 : 200)
                                        self.wordOpacity = 0
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        
                                        wordOffset = .zero
                                        wordOpacity = 1
                                        
                                        if timerEnded {
                                            viewModel.updateSwipe(word: viewModel.rootWord, swiped: swipedUp, isLast: true)
                                            isTimerEnd = true
                                        } else {
                                            viewModel.updateSwipe(word: viewModel.rootWord, swiped: swipedUp)
                                            viewModel.loadWords(forTopic: viewModel.currentTopic)
                                        }
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
                .blur(radius: showPauseAnimation ? 10 : 0)
                if isTimerEnd {
                    CustomAlertView(wordSwipeData: $viewModel.swipedWords,points: .constant(3))
                        .environmentObject(viewModel)
                        .frame(width: 370, height: 700)
                        .background(BackgroundView())
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 10)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                        )
                }
                if showPauseAnimation {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea(.all)
                        .zIndex(0)
                    PausedButton {
                        self.resumeTimer()
                    }
                    .transition(.scale)
                    .zIndex(1)
                }
            }
            .onAppear {
                self.isTimerRunning = true // Запуск таймера при появлении экрана
            }
            .navigationBarItems(leading: isViewVisible ? nil : Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Main")
                }
            })
        }
    }
    
    //func pauseTimer() {
    //    isTimerRunning = false
    //    showPauseAnimation = true
    //}
    
    func resumeTimer() {
        isTimerRunning = true
        timerPaused = false
        showPauseAnimation = false
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
