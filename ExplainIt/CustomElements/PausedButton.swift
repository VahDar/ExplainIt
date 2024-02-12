//
//  PausedButton.swift
//  ExplainIt
//
//  Created by Vakhtang on 12.02.2024.
//

import SwiftUI

struct PausedButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            SettingAnimationView(animationFileName: "Continue", loopMode: .loop)
                .frame(width: 200, height: 200)
                .scaleEffect(1.6)
                .padding()
        }
    }
}

#Preview {
    PausedButton(action: {})
}
