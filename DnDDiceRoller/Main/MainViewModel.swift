//
//  MainViewModel.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 20.11.2023.
//

import Combine
import SceneKit

final class MainViewModel: ObservableObject {  
    private let mainSceneManager = MainSceneManager(scene: .main)
    private let diceSceneManager = MainSceneManager(scene: .dice)
    
    @Published private(set) var mainScene: SCNScene?
    @Published private(set) var camera: SCNNode?
    
    init() {
        self.setupMainScene()
        self.setupCamera()
    }
    
    
    private func setupMainScene() {
        let scene = mainSceneManager.scene
        applyTextures(to: scene)
        mainScene = scene
    }
    
    private func setupCamera() {
        camera = mainSceneManager.getCamera()
    }
    
    private func applyTextures(to scene: SCNScene?) {
        let table = mainSceneManager.getNode(type: .table)
        Material.wood.apply(to: table)
        
        let d4 = diceSceneManager.getNode(type: .d4)
        Material.metalMirror.apply(to: d4)
        Decal.d4.apply(to: d4)
        
        let d6 = diceSceneManager.getNode(type: .d6)
        
        Material.metalRough.apply(to: d6)
        Decal.dN.apply(to: d6)
        
        let rotateAction = SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(-Double.pi * 2), around: SCNVector3(x: 0, y: 1, z: 1), duration: TimeInterval(10)))
      
        d6?.runAction(rotateAction)
    
//        let skyboxImages = UIImage(named: "Wall")
//        scene?.background.contents = skyboxImages
    }
    
    func spawnDice(type: DiceType) {
        
    }
}
