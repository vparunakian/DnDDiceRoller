//
//  DiceTypeMenuView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 30.11.2023.
//

import SwiftUI

struct DiceTypeMenuView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(NodeType.allDice) { dice in
                Button(action: {
                    viewModel.spawnDice(type: dice)
                }, label: {
                    Image(dice.rawValue)
                        .resizable()
                        .scaledToFit()
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
