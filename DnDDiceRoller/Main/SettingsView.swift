//
//  SettingsView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 22.11.2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Form {
            Picker("Dice Material", selection: $viewModel.material) {
                ForEach(Material.allCases) {
                    Text($0.displayName).tag($0)
                }
            }
            Picker("Dice Font", selection: $viewModel.decal) {
                ForEach(Decal.allCases) {
                    Text($0.displayName).tag($0)
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: MainViewModel())
}
