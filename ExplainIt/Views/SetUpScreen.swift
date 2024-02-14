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
//        var topics: [String] {
//            LocalizationService.shared.language == .ukrainian ? ["Загальна тема", "Гаррі Поттер"] : ["General", "Harry Potter"]
//        }
    
    var topics: [Topic] { 
        LocalizationService.shared.language == .ukrainian ? [
            Topic(name: "Загальна тема", difficulty: "Easy".localized(language), wordCount: countWordsInFile(named: "Загальна тема")),
        Topic(name: "Гаррі Поттер", difficulty: "Hard".localized(language), wordCount: countWordsInFile(named: "Гаррі Поттер"))
    ] : [
        Topic(name: "General", difficulty: "Easy", wordCount: countWordsInFile(named: "General")),
        Topic(name: "Harry Potter", difficulty: "Hard", wordCount: countWordsInFile(named: "Harry Potter"))
    ] }
    
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
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
                    Toggle("Turn on/off timer sound: ".localized(language), isOn: $viewModel.isSoundEnabled)
                        .tint(.blue)
                        .foregroundStyle(Color.blue)
                        .padding(.horizontal, 60)
                        .padding(.top, 40)
                }
                
                CustomDivider()
                VStack {
                    Text("Choose a Topic:".localized(language))
                        .foregroundStyle(.blue)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(minimum: UIScreen.main.bounds.width - 36, maximum: UIScreen.main.bounds.width - 36))], spacing: 15) {
                            ForEach(topics, id: \.name) { topic in
                                Button {
                                    selectedTopic = topic.name
                                } label: {
                                    ZStack {
                                        Image(viewModel.backgroundImageName(for: topic.name))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 100)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .opacity(0.5)
                                        VStack {
                                            Spacer()
                                            
                                            Text(topic.name)
                                                .foregroundStyle(Color.blue)
                                                .font(.headline)
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(selectedTopic == topic.name ? Color(red: 79/255, green: 74/255, blue: 183/255) : Color.black, lineWidth: 2)
                                                )
                                                .background(selectedTopic == topic.name ? Color(red: 79/255, green: 74/255, blue: 183/255) : Color.black.opacity(0.5))
                                                .offset(y: 37)
                                            
                                            Text("\(topic.difficulty) - \(topic.wordCount) words")
                                                .foregroundStyle(topic.difficulty == "Hard" && "Важко" ? Color.red : Color.green)
                                                .font(.headline)
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black,
                                                            lineWidth: 2)
                                                )
                                                .background( Color.black.opacity(0.5)
                                                )
                                                .offset(x: 100, y: -65)
                                        }
                                        
                                    }
                                }
                                .frame(height: 100)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 40)
                    }
                }
                .frame(height: 300)
                .padding()
                
                CustomDisabledButton(name: "Next".localized(language), action: {
                    startGame()
                    isGameScreenActive = true
                }, isDisabled: selectedTopic == nil)
                .padding()
            }
            .padding(.top, -240)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView())
            .navigationDestination(isPresented: $isGameScreenActive) {
                GameScreen()
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
            }
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
        viewModel.currentTopic = selectedTopic ?? "General"
        viewModel.roundTime = selectedDuration
        viewModel.requiredPoints = selectedPoint
        viewModel.loadWords(forTopic: viewModel.currentTopic)
        viewModel.isGameStarted = true
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
