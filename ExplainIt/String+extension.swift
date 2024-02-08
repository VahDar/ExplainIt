//
//  String+extension.swift
//  ExplainIt
//
//  Created by Vakhtang on 08.02.2024.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(
            self,
            comment: "\(self) could not be found in Localizable.xcstrings"
        )
    }
}
