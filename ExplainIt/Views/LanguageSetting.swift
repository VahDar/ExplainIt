//
//  LanguageSetting.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.02.2024.
//

import Foundation

class LanguageSetting: ObservableObject {
    
    @Published var languageCode: String
    
    init(languageCode: String) {
        self.languageCode = languageCode
    }
    
    func changeLanguage(to languageCode: String) {
        self.languageCode = languageCode
        UserDefaults.standard.setValue([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
