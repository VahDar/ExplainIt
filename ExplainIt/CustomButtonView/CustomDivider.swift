//
//  CustomDivider.swift
//  ExplainIt
//
//  Created by Vakhtang on 11.01.2024.
//

import SwiftUI

struct CustomDivider: View {
    let lineHeight: CGFloat = 2

       var body: some View {
           // Используем HStack, чтобы линия распространилась на всю ширину
           HStack {
               Path { path in
                   let y = lineHeight / 2
                   path.move(to: CGPoint(x: 0, y: y))
                   path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: y))
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
                   lineWidth: lineHeight
               )
               .blur(radius: 2)
           }
           .frame(height: lineHeight) // Задаем фрейм с желаемой высотой
           .padding(.top, 55)
       }
   }
struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        GradientLineView()
    }
}
