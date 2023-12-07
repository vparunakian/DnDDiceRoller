//
//  MainView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SceneKit
import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SceneView(scene: viewModel.mainScene,
                          pointOfView: viewModel.camera, options: [])
                .background(.secondary)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { location in
                    viewModel.throwDice()
                }
                
                DiceTypeMenuView()
                    .environmentObject(viewModel)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding()
            }
            .toolbar {
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Label("", systemImage: "gearshape.fill")
                }
                .popover(isPresented: $showingSettings) {
                    SettingsView()
                        .environmentObject(viewModel)
                        .frame(minWidth: 400, minHeight: 150)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
