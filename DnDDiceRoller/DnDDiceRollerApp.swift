//
//  DnDDiceRollerApp.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SwiftUI

@main
struct DnDDiceRollerApp: App {
    @StateObject private var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
