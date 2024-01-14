//
//  GradientLineView.swift
//  ExplainIt
//
//  Created by Vakhtang on 29.08.2023.
//

import SwiftUI

struct GradientLineView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let startPoint = CGPoint(x: 0, y: geometry.size.height / 2)
                let endPoint = CGPoint(x: geometry.size.width, y: geometry.size.height / 2)
                
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
            .stroke(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(red: 36/255, green: 33/255, blue: 142/255).opacity(0.4),
                            Color(red: 36/255, green: 33/255, blue: 142/255),
                            Color.white,
                            Color(red: 36/255, green: 33/255, blue: 142/255),
                            Color(red: 36/255, green: 33/255, blue: 142/255).opacity(0.4)
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 2
            )
            .blur(radius: 2)
            
        }
        .padding(.top, 55)
    }
}

struct GradientLineView_Previews: PreviewProvider {
    static var previews: some View {
        GradientLineView()
    }
}
