//
//  SetUpScreen.swift
//  ExplainIt
//
//  Created by Vakhtang on 25.09.2023.
//

import SwiftUI

struct SetUpScreen: View {
    
    //MARK: - Properties
    private var language = LocalizationService.shared.language
    @State var selectedDuration: Int = 30
    @State var selectedPoint: Int = 20
    @State private var teamName = ["Manatee"]
    @State private var timerDurations = [5, 30, 60, 90, 120]
    @State private var requiredPoints = [5, 20, 30, 40, 50, 60, 70, 80]
    @State private var isButtonPressed = false
    @State private var isGameScreenActive = false
    @State private var selectedTopic: String?
    
    @EnvironmentObject var wordsAndTeamsManager: WordsAndTeamsManager
    @EnvironmentObject var gameSettingsManager: GameSettingsManager
    @EnvironmentObject var persistenceManager: PersistenceManager
    @Environment(\.presentationMode) var presentationMode
    
    var topics: [Topic] {
        LocalizationService.shared.language == .ukrainian ? [
            Topic(name: "Загальна тема", difficulty: "Easy".localized(language), wordCount: countWordsInFile(named: "Загальна тема")),
            Topic(name: "Гаррі Поттер", difficulty: "Hard".localized(language), wordCount: countWordsInFile(named: "Гаррі Поттер"))
        ] : [
            Topic(name: "General", difficulty: "Easy", wordCount: countWordsInFile(named: "General")),
            Topic(name: "Harry Potter", difficulty: "Hard", wordCount: countWordsInFile(named: "Harry Potter"))
        ] }
    
   
    
    
    // MARK: - Initializer
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    CustomDivider()
                        .offset(y: 30)
                    HStack(alignment: .center) {
                        Text("Required Points:".localized(language))
                            .foregroundStyle(Color.blue)
                        Picker("Required Points", selection: $selectedPoint) {
                            ForEach(requiredPoints, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.top, 40)
                    
                    HStack(alignment: .center) {
                        
                        Text("Round Time:".localized(language))
                            .foregroundStyle(.blue)
                        
                        Picker("Round Time", selection: $selectedDuration) {
                            ForEach(timerDurations, id: \.self) {
                                Text($0, format: .number)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color.clear)
                    }
                    .padding(.top, 40)
                    VStack(alignment: .center) {
                        Toggle("Turn on/off timer sound: ".localized(language), isOn: $gameSettingsManager.isSoundEnabled)
                            .tint(.blue)
                            .foregroundStyle(Color.blue)
                            .padding(.horizontal, 60)
                            .padding(.top, 40)
                    }
                    
                    CustomDivider()
                        .padding(.top)
                    VStack {
                        Text("Choose a Topic:".localized(language))
                            .foregroundStyle(.blue)
                        
                        
                        LazyVGrid(columns: [GridItem(.flexible(minimum: UIScreen.main.bounds.width - 36, maximum: UIScreen.main.bounds.width - 36))], spacing: 15) {
                            ForEach(topics, id: \.name) { topic in
                                Button {
                                    selectedTopic = topic.name
                                } label: {
                                    Image(wordsAndTeamsManager.backgroundImageName(for: topic.name))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 100)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .opacity(0.5)
                                        .overlay (
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Text("\(topic.difficulty) - \(topic.wordCount) words")
                                                        .foregroundStyle(topic.difficulty == "Hard".localized(language) ? Color.red : Color.green)
                                                        .font(.headline)
                                                        .padding(5)
                                                        .background(RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black,
                                                                    lineWidth: 2)
                                                        )
                                                        .background( Color.black.opacity(0.5)
                                                        )
                                                        .padding([.top, .trailing], 5)
                                                }
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    Text(topic.name)
                                                        .foregroundStyle(Color.blue)
                                                        .font(.headline)
                                                        .padding(5)
                                                        .background(RoundedRectangle(cornerRadius: 5)
                                                            .stroke(selectedTopic == topic.name ? Color(red: 79/255, green: 74/255, blue: 183/255) : Color.black, lineWidth: 2)
                                                        )
                                                        .background(selectedTopic == topic.name ? Color(red: 79/255, green: 74/255, blue: 183/255) : Color.black.opacity(0.5)
                                                        )
                                                    Spacer()
                                                }
                                                .padding(.bottom, 2)
                                            }
                                            ,alignment: .topTrailing
                                            
                                        )
                                    
                                }
                                .frame(height: 100)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 40)
                    }
                    
                    .frame(height: 300)
                    .padding()
                    
                    CustomDisabledButton(name: "Next".localized(language), action: {
                        startGame()
                        isGameScreenActive = true
                    }, isDisabled: selectedTopic == nil)
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .navigationDestination(isPresented: $isGameScreenActive) {
                GameScreen()
                    .environmentObject(wordsAndTeamsManager)
                    .environmentObject(gameSettingsManager)
                    .environmentObject(persistenceManager)
                    .navigationBarBackButtonHidden(true)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .navigationBarItems(leading: Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Image(systemName: "chevron.left")
                    Text("Team")
                }
            })
        }
        
    }
    
    // MARK: - Methods
    func startGame() {
        wordsAndTeamsManager.currentTopic = selectedTopic ?? "General"
        gameSettingsManager.roundTime = selectedDuration
        wordsAndTeamsManager.requiredPoints = selectedPoint
        wordsAndTeamsManager.loadWords(forTopic: wordsAndTeamsManager.currentTopic)
        wordsAndTeamsManager.isGameStarted = true
    }
}

func countWordsInFile(named fileName: String) -> Int {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "txt"),
          let content = try? String(contentsOfFile: path) else { return 0 }
    return content.components(separatedBy: "\n").filter { !$0.isEmpty }.count
}

// MARK: - Preview
struct SetUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SetUpScreen()
    }
}


// MARK: - Topic Information
struct Topic {
    let name: String
    let difficulty: String
    let wordCount: Int
}
