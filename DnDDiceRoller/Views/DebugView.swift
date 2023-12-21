//
//  DebugView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 20.12.2023.
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        ZStack {
            Text("\(viewModel.lastNumberDice)")
                .hidden()
                .accessibilityIdentifier("diceNumber")
            if viewModel.isDebugMode {
                DebugTextView(nodeStats: viewModel.nodeStats)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

#Preview {
    DebugView()
        .environmentObject(MainViewModel())
}
