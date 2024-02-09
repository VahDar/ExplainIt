//
//  String+extension.swift
//  ExplainIt
//
//  Created by Vakhtang on 08.02.2024.
//

import Foundation

enum Language: String {
    case english_us = "en"
    case ukrainian = "uk"
}

extension String {
   
    var localized: String {
            NSLocalizedString(
                self,
                comment: "\(self) could not be found in Localizable.xcstrings"
            )
        }
    
    func localized(_ language: Language) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }

    func localized(_ language: Language, args: CVarArg...) -> String {
           let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
           let bundle = path.flatMap(Bundle.init(path:)) ?? .main
           let format = NSLocalizedString(self, bundle: bundle, value: "", comment: "")
           return String(format: format, locale: Locale.current, arguments: args)
       }
//    func localized(_ language: Language, args arguments: CVarArg...) -> String {
//        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
//        let bundle: Bundle
//        if let path = path {
//            bundle = Bundle(path: path) ?? .main
//        } else {
//            bundle = .main
//        }
//        return String(format: localized(bundle: bundle), arguments: arguments)
//    }

    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, bundle: bundle, value: "", comment: "")
    }
}

class LocalizationService {
    
    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")

    private init() {}
    
    var language: Language {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: "language") else {
                return .english_us
            }
            return Language(rawValue: languageString) ?? .english_us // - дефолтне значення мови у програмі
        } set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
}
//
//class LocalizationService {
//    static let shared = LocalizationService()
//    var language: Language = .english_us
//}
