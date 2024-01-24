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
            Group {
                Text("Winner: ").font(.title2)
                + Text("\(viewModel.winners)")
                    .font(.title)
            }
            .foregroundStyle(Color.blue)
            .padding()
            .offset(y: -140)
            SettingAnimationView(animationFileName: "astronaut", loopMode: .loop)
                .frame(width: 100, height: 100)
                .scaleEffect(0.2)
                .padding()
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
    }
}

#Preview {
    WinnerAlertView()
}
