//
//  GameScene.swift
//  Final Project Game
//
//  Created by Laporionok, Rostislav (513077) on 4/17/25.
//

import SpriteKit
import SwiftUI


class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var test = SKSpriteNode()
    var player = SKSpriteNode()
    var theGround = SKSpriteNode()
    var lastPosition: CGPoint = .zero
    
    var isOnGround: Bool = true
    
    var character: SKSpriteNode!
    var frameIndex = 0
    @Published var characterState: String = "idle" //stores states: idle, walk, jump
    
    
    //"idle_0", "idle_1", "idle_2", "idle_3"
    var idleStrings = ["Farmer_Idle_0", "Farmer_Idle_1"]
    var idleFrames: [SKTexture] { idleStrings.map {SKTexture(imageNamed: $0) } } //Used AI for this
    
    var walkStrings = ["Farmer_Walk_0","Farmer_Walk_1","Farmer_Walk_2","Farmer_Walk_3"]
    var walkFrames: [SKTexture] { walkStrings.map {SKTexture(imageNamed: $0) } }
    
    var jumpStrings = ["Farmer_Jump_Frame"]
    var jumpFrames: [SKTexture] { jumpStrings.map {SKTexture(imageNamed: $0) } }
    
    
    
    let groundCategory: UInt32 = 1
    let objectCategory: UInt32 = 2
    
    struct PhysicsCategory {
        static let character: UInt32 = 0x1 << 0
        static let ground: UInt32 = 0x1 << 1
    }
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        let ground = SKNode()
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.character
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width + 90, height: size.height))
        ground.physicsBody?.node?.name = "ground"
        ground.physicsBody?.isDynamic = false
        
        addChild(ground)
        
        
        
        
        
        
        
        theGround = SKSpriteNode(color: .orange, size: CGSize(width: 500, height: 20))
        theGround.position = CGPoint(x: size.width / 2, y: 100)
        theGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 20))
        theGround.physicsBody?.categoryBitMask = PhysicsCategory.ground
        theGround.physicsBody?.collisionBitMask = PhysicsCategory.character
        theGround.physicsBody?.node?.name = "theGround"
        theGround.physicsBody?.affectedByGravity = false
        theGround.physicsBody?.isDynamic = false
        theGround.physicsBody?.allowsRotation = false
        
        
        
        
        
        
        
        addChild(theGround)
        
    }
    override func didMove(to view: SKView) {
        character = SKSpriteNode(texture: idleFrames[0])
        character.size = CGSize(width: 50, height: 50)
        character.position = CGPoint(x: size.width / 2,y: size.height / 2)
        
        
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 51, height: 51))
        character.physicsBody?.collisionBitMask = PhysicsCategory.ground
        character.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.affectedByGravity = true
        character.physicsBody?.restitution = 0.0
        
        addChild(character)
        
        startIdleAnimation()
        print(frame)
        print(character.position)
        
        lastPosition = character.position
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = [contact.bodyA, contact.bodyB]
        if bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.character}) && bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.ground}) {
            
            isOnGround = true
            characterState = "idle"
            startIdleAnimation()
        }
    }
    
    func startIdleAnimation(){
        characterState = "idle"
        character.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.5)),withKey: "idle")
    }
    
    func moveLeft() {
        if characterState != "walk" {
            characterState = "walk"
            character.xScale = -1 // flip left
            character.removeAllActions()
            character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)), withKey: "walk")
        }
        character.run(SKAction.moveBy(x: -8, y: 0, duration: 0.1))
    }
    func moveRight() {
        if characterState != "walk" {
            characterState = "walk"
            character.xScale = 1 // flip right
            character.removeAllActions()
            character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)), withKey: "walk")
        }
        character.run(SKAction.moveBy(x: 8, y: 0, duration: 0.1))
    }
    
    
    func jump(){
        guard isOnGround else {return}
        characterState = "jump"
        character.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.5))
        character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        isOnGround = false
    }
        
        
        func use() {
            print("Use Button Pressed")
        }
        
        func stopMoving() {
            if characterState != "idle" {
                characterState = "idle"
                character.removeAllActions()
                startIdleAnimation()
            }
        }
        
        
    }
    
    #Preview {
        ContentView()
    }
