import SwiftUI

struct GameScreen: View {
    @State private var isViewVisible = false
    @State private var words = ["Sun", "Moon", "Earth"]
    @State private var randomIndex = 0
    private let timerView = TimerView(timerDuration: 60)
    
    var body: some View {
        NavigationStack {
            VStack {
                if !isViewVisible {
                    VStack {
                        Text("If you guessed the word swipe up, if not, swipe down.")
                            .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .padding(.leading, 25)
                            .padding(.trailing, 25)
                        
                        CustomButton(name: "Start") {
                            isViewVisible = true
                            timerView.startTimer()
                            randomIndex = Int.random(in: 0..<words.count)
                        }
                    }
                }
                if isViewVisible {
                    ZStack {
                        TimerView(timerDuration: 60)
                        Text(words[randomIndex])
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
                                            randomIndex = Int.random(in: 0..<words.count)
                                        } else if swipeDistance > 0 {
                                           randomIndex = Int.random(in: 0..<words.count)
                                        }
                                    })
                            )
//                            .contentShape(Rectangle())
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                BackgroundView()
            )
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
