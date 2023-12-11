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
        HStack(spacing: 2) {
            ForEach(NodeType.allDice) { dice in
                Button(action: {
                    viewModel.spawnDice(type: dice)
                }, label: {
                    if UIImage(named: dice.rawValue.uppercased()) != nil {
                        Label("", image: dice.rawValue.uppercased())
                    } else {
                        Label("", image: "D10")
                    }
                })
            }
        }
    }
}

#Preview {
    DiceTypeMenuView()
        .environmentObject(MainViewModel())
}
