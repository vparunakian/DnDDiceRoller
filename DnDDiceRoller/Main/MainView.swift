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
    
    var body: some View {
        ZStack {
            SceneView(scene: viewModel.mainScene,
                      pointOfView: viewModel.camera, options: [.allowsCameraControl])
                .background(.secondary)
                .edgesIgnoringSafeArea(.all)
            HStack {
                Menu {
                    ForEach(DiceType.allCases) { dice in
                        Button(action: {
                            viewModel.spawnDice(type: dice)
                        }, label: {
                            Text(dice.rawValue.uppercased())
                        })
                    }
                } label: {
                    Label("", systemImage: "dice.fill")
                        .font(.system(size: 40))
                        .tint(.red)
                        .controlSize(.large)

                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .ignoresSafeArea(.all)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.trailing)
        }
    }
}

#Preview {
    MainView()
        .previewDevice(PreviewDevice(rawValue: "iPad Air 5th generation"))
}
