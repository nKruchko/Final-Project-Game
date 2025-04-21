//
//  GameScene.swift
//  Final Project Game
//
//  Created by Laporionok, Rostislav (513077) on 4/17/25.
//

import SpriteKit
import SwiftUI




class GameScene: SKScene, SKPhysicsContactDelegate {
    @State var test = SKSpriteNode()
    
    let groundCategory: UInt32 = 1
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        let ground = SKNode()
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        ground.physicsBody?.node?.name = "ground"
        
        test = SKSpriteNode(imageNamed: "Terrence")
        test.position = CGPoint(x: size.width / 2, y: size.height / 2)
        test.size = CGSize(width: 100, height: 100)
        test.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        
        addChild(test)
        addChild(ground)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#Preview {
    ContentView()
}
