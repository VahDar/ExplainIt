//
//  SettingAnimationView.swift
//  ExplainIt
//
//  Created by Vakhtang on 23.01.2024.
//

import SwiftUI
import Lottie

struct SettingAnimationView: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode
            
    func updateUIView(_ uiView: UIViewType, context: Context) {}
            
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
            animationView.loopMode = loopMode
            animationView.play()
            animationView.contentMode = .scaleAspectFill
            return animationView
    }

}

#Preview {
    SettingAnimationView(animationFileName: "SettingAnimation", loopMode: .loop)
}
