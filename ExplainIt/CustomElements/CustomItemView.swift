//
//  CustomItemView.swift
//  ExplainIt
//
//  Created by Vakhtang on 20.01.2024.
//

import SwiftUI

struct CustomItemView: View {
    let item: Item
    var body: some View {
        GeometryReader { reader in
            
        }
    }
}

//#Preview {
//    CustomItemView()
//}

struct Item: Identifiable {
    let id = UUID()
    let title: String
    let image: String
}
