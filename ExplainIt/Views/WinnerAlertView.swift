//
//  WinnerAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 23.01.2024.
//

import SwiftUI

struct WinnerAlertView: View {
    var body: some View {
        SettingAnimationView(animationFileName: "weee", loopMode: .loop)
            .frame(width: 100, height: 100)
            .scaleEffect(0.7)
        SettingAnimationView(animationFileName: "Animation - 1706030765821", loopMode: .loop)
            .frame(width: 50, height: 50)
            .scaleEffect(0.7)
            
    }
}

#Preview {
    WinnerAlertView()
}
