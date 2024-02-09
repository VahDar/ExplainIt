//
//  TextGradient.swift
//  ExplainIt
//
//  Created by Vakhtang on 09.02.2024.
//

import SwiftUI

struct TextGradient: View {
    
    var body: some View {
            Text("SPACE ALIAS")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.clear)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        .mask(
                            Text("SPACE ALIAS")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                        )
                )
                .shadow(color: .blue, radius: 8, x: 0, y: 0)
        }
}

#Preview {
    TextGradient()
}
