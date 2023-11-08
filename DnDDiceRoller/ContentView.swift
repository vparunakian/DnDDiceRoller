//
//  ContentView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SceneKit
import SwiftUI

struct ContentView: View {
    private let mainScene = makeScene()
    
    var body: some View {
        SceneView(scene: mainScene,
                  pointOfView: setUpCamera())
            .background(.secondary)
            .edgesIgnoringSafeArea(.all)
    }
    
    static func makeScene() -> SCNScene? {
        let scene = SCNScene(named: "MainScene.scn")
        applyTextures(to: scene)
        return scene
    }
    
    func setUpCamera() -> SCNNode? {
        let cameraNode = mainScene?.rootNode
            .childNode(withName: "camera", recursively: false)
        return cameraNode
    }
    
    static func applyTextures(to scene: SCNScene?) {
        let table = scene?.rootNode
            .childNode(withName: "table", recursively: false)
        let tableMat = Material.tableMaterial
        table?.geometry?.materials.append(tableMat)
        
        let dice = scene?.rootNode.childNode(withName: "dice", recursively: false)
        let diceMat = Material.diceMaterial
        dice?.geometry?.materials = Array(repeating: diceMat, count: 6)
        
        let skyboxImages = UIImage(named: "Wall")
        scene?.background.contents = skyboxImages
    }
}

#Preview {
    ContentView()
}
