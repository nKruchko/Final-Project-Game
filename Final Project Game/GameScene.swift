//
//  GameScene.swift
//  Final Project Game
//
//  Created by Laporionok, Rostislav (513077) on 4/17/25.
//

import SpriteKit
import SwiftUI




class GameScene: SKScene, SKPhysicsContactDelegate {
    var test = SKSpriteNode()
    
    
    var character: SKSpriteNode!
    var frameIndex = 0
    var characterState = "idle" //stores states: idle, walk, jump
    
    
    //"idle_0", "idle_1", "idle_2", "idle_3"
    var idleFrames: [SKTexture] = []
    var walkFrames: [SKTexture] = []
    var jumpFrames: [SKTexture] = []
    
    
    
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
    override func didMove(to view: SKView) {
        loadFrames()
        character = SKSpriteNode(texture: idleFrames[0])
        character.position = CGPoint(x: size.width/2,y: size.height/2)
        addChild(character)
        
        startIdleAnimation()
    }
    func loadFrames(){
        for i in 0...3{
            idleFrames.append(SKTexture(imageNamed: "idle\(i)"))
            walkFrames.append(SKTexture(imageNamed: "walk\(i)"))
            jumpFrames.append(SKTexture(imageNamed: "jump\(i)"))
        }
    }
    func startIdleAnimation(){
        characterState = "idle"
        character.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.2)),withKey: "idle")
    }
    func moveLeft(){
        characterState = "walk"
        character.xScale = -1 //flips character to the left
        character.removeAllActions()
        character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)),withKey: "walk")
        character.run(SKAction.moveBy(x: -10, y: 0, duration: 0.1))

    }
    func moveRight(){
        characterState = "walk"
        character.xScale = 1 //flips character to the right
        character.removeAllActions()
        character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)),withKey: "walk")
        character.run(SKAction.moveBy(x: 10, y: 0, duration: 0.1))

    }
    func jump(){
        characterState = "jump"
        character.removeAllActions()
        character.run(SKAction.repeatForever(SKAction.animate(with: jumpFrames, timePerFrame: 0.1)))
        let jumpUp = SKAction.moveBy(x: 0, y: 50, duration: 0.2)
        let jumpDown = SKAction.moveBy(x: 0, y: -50, duration: 0.2)
        let sequence = SKAction.sequence([jumpUp,jumpDown])
        character.run(sequence)
        
        //return to idle
        run(SKAction.wait(forDuration: 0.5)){
            self.startIdleAnimation()
        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

#Preview {
    ContentView()
}
