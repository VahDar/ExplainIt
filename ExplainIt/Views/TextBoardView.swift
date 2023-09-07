//
//  TextBoardView.swift
//  ExplainIt
//
//  Created by Vakhtang on 07.09.2023.
//

import SwiftUI

struct TextBoardView: View {
    
    var body: some View {
            Text("If you guessed the word swipe up, if not, swipe down.")
                .foregroundColor(Color(red: 79/255, green: 74/255, blue: 183/255)
                )
                .font(.system(size: 25))
                .fontWeight(.bold)
        
    }
}

struct TextBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TextBoardView()
    }
}
