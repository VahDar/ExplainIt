//
//  WinnerAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 23.01.2024.
//

import SwiftUI

struct WinnerAlertView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        VStack {
            Text("\(viewModel.winners)")
                .foregroundStyle(Color.blue)
                .font(.title)
                .padding()
            SettingAnimationView(animationFileName: "astronaut", loopMode: .loop)
                .frame(width: 100, height: 100)
                .scaleEffect(0.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
    }
}

#Preview {
    WinnerAlertView()
}
