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
    var player = SKSpriteNode()
    var theGround = SKSpriteNode()
    
    
    var character: SKSpriteNode!
    var frameIndex = 0
    var characterState = "idle" //stores states: idle, walk, jump
    
    
    //"idle_0", "idle_1", "idle_2", "idle_3"
    var idleStrings = ["Farmer_Idle_0", "Farmer_Idle_1"]
    var idleFrames: [SKTexture] { idleStrings.map {SKTexture(imageNamed: $0) } } //Used AI for this
    
    var walkStrings = ["Farmer_Walk_0","Farmer_Walk_1"]
    var walkFrames: [SKTexture] { walkStrings.map {SKTexture(imageNamed: $0) } }
    
    var jumpStrings = ["Farmer_Jump_Frame"]
    var jumpFrames: [SKTexture] { jumpStrings.map {SKTexture(imageNamed: $0) } }
    
    
    
    let groundCategory: UInt32 = 1
    let objectCategory: UInt32 = 2
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        let ground = SKNode()
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        ground.physicsBody?.node?.name = "ground"
        
        theGround = SKSpriteNode(color: .orange, size: CGSize(width: 500, height: 20))
        theGround.position = CGPoint(x: size.width / 2, y: 100)
        theGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 20))
        theGround.physicsBody?.categoryBitMask = groundCategory
        theGround.physicsBody?.collisionBitMask = objectCategory
        theGround.physicsBody?.node?.name = "theGround"
        theGround.physicsBody?.affectedByGravity = false
        theGround.physicsBody?.isDynamic = false
        
        
        
        
        
        
        
        addChild(ground)
        addChild(theGround)
        
    }
    override func didMove(to view: SKView) {
        character = SKSpriteNode(texture: idleFrames[0])
        character.size = CGSize(width: 50, height: 50)
        character.position = CGPoint(x: size.width/2,y: size.height/2)
        
        
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        character.physicsBody?.collisionBitMask = groundCategory
        character.physicsBody?.contactTestBitMask = groundCategory
        character.physicsBody?.categoryBitMask = objectCategory
        
        addChild(character)
        
        startIdleAnimation()
    }

    func startIdleAnimation(){
        characterState = "idle"
        character.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.5)),withKey: "idle")
    }
    func moveLeft(){
        characterState = "walk"
        character.xScale = -1 //flips character to the left
        character.removeAllActions()
        character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)),withKey: "walk")
        character.run(SKAction.moveBy(x: -32, y: 0, duration: 0.1))
        //return to idle
        run(SKAction.wait(forDuration: 0.5)){
            self.startIdleAnimation()
        }

    }
    func moveRight(){
        characterState = "walk"
        character.xScale = 1 //flips character to the right
        character.removeAllActions()
        character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)),withKey: "walk")
        character.run(SKAction.moveBy(x: 32, y: 0, duration: 0.1))
        //return to idle
        run(SKAction.wait(forDuration: 0.5)){
            self.startIdleAnimation()
        }

    }
    func jump(){
        characterState = "jump"
        character.removeAllActions()
        character.run(SKAction.repeatForever(SKAction.animate(with: jumpFrames, timePerFrame: 0.1)))
        let jumpUp = SKAction.moveBy(x: 0, y: 64, duration: 0.2)
        let jumpDown = SKAction.moveBy(x: 0, y: -64, duration: 0.2)
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
