//
//  CustomAlertView.swift
//  ExplainIt
//
//  Created by Vakhtang on 14.01.2024.
//

import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        Text("\(viewModel.teams[viewModel.currentTeamIndex])")
            .foregroundStyle(Color.blue)
    }
}

#Preview {
    CustomAlertView()
}
