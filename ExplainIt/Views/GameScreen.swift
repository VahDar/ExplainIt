import SwiftUI

struct GameScreen: View {
    @State private var isViewVisible = false
   private let timerView = TimerView()
    
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
                        }
                    }
                }
                if isViewVisible {
                    ZStack {
                        TimerView()
                        Text("Game started")
                            .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                        
                        
                    }
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
