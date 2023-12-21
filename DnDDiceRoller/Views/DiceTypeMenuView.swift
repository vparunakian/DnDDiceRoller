//
//  DiceTypeMenuView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 30.11.2023.
//

import SwiftUI

struct DiceTypeMenuView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    private let spacing = 4.0

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(NodeType.allDice) { dice in
                Button(action: {
                    viewModel.spawnDice(type: dice)
                }, label: {
                    Image(dice.rawValue)
                        .resizable()
                        .scaledToFit()
                        .accessibilityLabel(dice.rawValue)
                })
                .accessibilityIdentifier(dice.rawValue)
            }
        }
    }
}

#Preview {
    DiceTypeMenuView()
        .environmentObject(MainViewModel())
}
