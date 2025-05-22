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
    var plant = SKSpriteNode()
    var numOfSeeds = 0
    var SeedPickUP = SKSpriteNode()
    var SeedBad = SKSpriteNode()
    var SeedText = SKLabelNode(text: "")


    var lastPosition: CGPoint = .zero
    var isOnGround: Bool = true
    var grassBlock = SKSpriteNode()
    var xVal = 15
    var yVal = 100
    var rep = 0
    var score = 100
    var currentLevel = 1
    
    let level1 = [
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        "          GGG",
        " P   GGG     ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level2 = [
        "             ",
        "GGG          ",
        "             ",
        "             ",
        "             ",
        "             ",
        " P   GGG     ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level3 = [
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        " P   GGG     ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level4 = [
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        " P   GGG     ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level5 = [
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        "             ",
        " P   GGG     ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    var character: SKSpriteNode!
    var frameIndex = 0
    @Published var characterState: String = "idle" //stores states: idle, walk, jump
    //grass color
    let darkGrassGreen = SKColor(red: 0.1, green: 0.75, blue: 0.1, alpha: 1.0)
    
    
    //"idle_0", "idle_1", "idle_2", "idle_3"
    var idleStrings = ["Farmer_Idle_0", "Farmer_Idle_1"]
    var idleFrames: [SKTexture] { idleStrings.map {SKTexture(imageNamed: $0) } } //Used AI for this
    
    var walkStrings = ["Farmer_Walk_0","Farmer_Walk_1","Farmer_Walk_2","Farmer_Walk_3"]
    var walkFrames: [SKTexture] { walkStrings.map {SKTexture(imageNamed: $0) } }
    
    var jumpStrings = ["Farmer_Jump_Frame"]
    var jumpFrames: [SKTexture] { jumpStrings.map {SKTexture(imageNamed: $0) } }
    
    var growStrings = ["Plant_Grow_Sun_0","Plant_Grow_Sun_1","Plant_Grow_Sun_2","Plant_Grow_Sun_3"]
    var growFrames: [SKTexture] {growStrings.map{SKTexture(imageNamed: $0)}}
    
    
    let groundCategory: UInt32 = 1
    let objectCategory: UInt32 = 2
    
    struct PhysicsCategory {
        static let character: UInt32 = 0x1 << 0
        static let ground: UInt32 = 0x1 << 1
        static let plant: UInt32 = 0x1 << 3
        static let lava: UInt32 = 0x1 << 4
        
    }
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        let ground = SKNode()
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.character
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width + 90, height: size.height))
        ground.physicsBody?.node?.name = "ground"
        ground.physicsBody?.isDynamic = false
        
        SeedText.position = CGPoint(x: (110) , y: (size.height - 15) )
        SeedText.zPosition = 999
        SeedText.fontSize = 30
        SeedText.text = "\(3)"
        SeedText.fontName = "Courier-Bold"
        
        makeSeed(xposition: 200, yposition: 130)
        
        addChild(SeedText)
        addChild(ground)
        
        
        
        
        
        
        
        
        
        theGround = SKSpriteNode(color: darkGrassGreen, size: CGSize(width: 500, height: 20))
        theGround.position = CGPoint(x: size.width / 2, y: 100)
        theGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 20))
        theGround.physicsBody?.categoryBitMask = PhysicsCategory.ground
        theGround.physicsBody?.collisionBitMask = PhysicsCategory.character
        theGround.physicsBody?.node?.name = "theGround"
        theGround.physicsBody?.affectedByGravity = false
        theGround.physicsBody?.isDynamic = false
        theGround.physicsBody?.allowsRotation = false
        
        
        
        
        
        addChild(SeedText)
        addChild(ground)
        
    }
    var cloudTextures: [SKTexture] = []
    override func didMove(to view: SKView) {
       
        
        cloudTextures = [
            SKTexture(imageNamed: "Cloud_1"),
            SKTexture(imageNamed: "Cloud_2"),
            SKTexture(imageNamed: "Cloud_3")
        ]
        
        let spawnCloud = SKAction.run{
            let texture = self.cloudTextures.randomElement()!
            let cloud = SKSpriteNode(texture: texture)
            cloud.size.width = cloud.size.width/5
            cloud.size.height = cloud.size.height/5
            
            let startX = -cloud.size.width
            let maxY = CGFloat(500)
            let randomY = self.size.height-CGFloat.random(in: 0...maxY)
            
            cloud.position = CGPoint(x: startX, y: randomY)
            self.addChild(cloud)
            let distance = self.size.width + cloud.size.width * 2
            let speed = CGFloat.random(in: 20...50)
            let duration = TimeInterval(distance / speed)
            
            let move = SKAction.moveBy(x: distance, y: 0, duration: duration)
            let remove = SKAction.removeFromParent()
            cloud.run(SKAction.sequence([move, remove]))
        }
        
        let wait = SKAction.wait(forDuration: 2.0, withRange: 1.0)
        let sequence = SKAction.sequence([spawnCloud, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)

        numOfSeeds = 3
        SeedBad = SKSpriteNode(imageNamed: "Seed_Packet")
        SeedBad.size = CGSize(width: 90, height: 90)
        SeedBad.position = CGPoint(x: CGFloat(50) , y: (size.height - 55) )
        SeedBad.zPosition = 999
        addChild(SeedBad)
        
        character = SKSpriteNode(texture: idleFrames[0])
        character.size = CGSize(width: 50, height: 50)
        character.position = CGPoint(x: size.width / 2,y: size.height / 2)
        character.zPosition = 998
        
        
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 51))
        character.physicsBody?.collisionBitMask = PhysicsCategory.ground
        character.physicsBody?.contactTestBitMask = PhysicsCategory.lava | PhysicsCategory.ground
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.affectedByGravity = true
        character.physicsBody?.restitution = 0.0
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -100
        background.alpha = 1.0
        background.name = "background"
        
        
        addChild(background)
        addChild(character)
        
        
        
        startIdleAnimation()
        print(frame)
        print(character.position)
        
        loadLevel(level1)
        
        lastPosition = character.position
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.character &&
            secondBody.categoryBitMask == PhysicsCategory.lava {
            characterDidTouchLava()
        }
        
        let skView = SKView()
        skView.preferredFramesPerSecond = 30 // caps to 30 FPS
        
        let bodies = [contact.bodyA, contact.bodyB]
        if bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.character}) && bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.ground}) {
            
            isOnGround = true
            characterState = "idle"
            startIdleAnimation()
        }
        
        if(contact.bodyA.node?.name == "Seed")
        {
            contact.bodyA.node?.removeFromParent()
            numOfSeeds += 1
            
            SeedText.text = "\(numOfSeeds)"
            print("\(numOfSeeds)")

        }

    }
    
    func characterDidTouchLava() {
        character.physicsBody?.velocity = .zero
        
        character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
        print("Touched Lava")
    }
    
    
    func startIdleAnimation(){
        characterState = "idle"
        character.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.5)),withKey: "idle")
    }
    
    func moveLeft() {
        jump()
        if characterState != "walk" {
            characterState = "walk"
            character.xScale = -1 // flip left
            character.removeAllActions()
            character.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.2)), withKey: "walk")
        }
        character.run(SKAction.moveBy(x: -8, y: 0, duration: 0.1))
    }
    func moveRight() {
        jump()
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
        
        let jumpSound = SKAction.playSoundFileNamed("e", waitForCompletion: false)
        
        let jumpAnimation = SKAction.animate(with: jumpFrames, timePerFrame: 0.5)
        
        character.run(SKAction.group([jumpAnimation, jumpSound]))
        
        character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 45))
        isOnGround = false
    }
    
    
    func makeSeed(xposition:Int,yposition:Int) {
        SeedPickUP = SKSpriteNode(imageNamed: "Seed")
        SeedPickUP.size = CGSize(width: 45, height: 45)
        SeedPickUP.position = CGPoint(x: xposition, y: yposition)
        SeedPickUP.zPosition = 999
        
        SeedPickUP.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 46, height: 46))
        SeedPickUP.physicsBody?.node?.name = "Seed"
        SeedPickUP.physicsBody?.collisionBitMask = PhysicsCategory.ground
        SeedPickUP.physicsBody?.contactTestBitMask = PhysicsCategory.character
        SeedPickUP.physicsBody?.categoryBitMask = PhysicsCategory.plant
        SeedPickUP.physicsBody?.allowsRotation = false
        SeedPickUP.physicsBody?.affectedByGravity = false
        SeedPickUP.physicsBody?.restitution = 0.0
        
        addChild(SeedPickUP)
    }
    
    func use() {
        print("Use Button Pressed")
        if(numOfSeeds>0)
        {
            plant = SKSpriteNode(texture: growFrames[0])
            plant.size = CGSize(width: 50, height: 50)
            plant.position = character.position
            
            plant.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 51, height: 51))
            plant.physicsBody?.collisionBitMask = PhysicsCategory.ground
            plant.physicsBody?.contactTestBitMask = PhysicsCategory.ground
            plant.physicsBody?.categoryBitMask = PhysicsCategory.plant
            plant.physicsBody?.allowsRotation = false
            plant.physicsBody?.affectedByGravity = true
            plant.physicsBody?.restitution = 0.0
            plant.run((SKAction.animate(with: growFrames, timePerFrame: 3)), withKey: "grow")
            addChild(plant)
            numOfSeeds -= 1
            
            SeedText.text = "\(numOfSeeds)"
            print("\(numOfSeeds)")
        }
        
    }
    
    func stopMoving() {
        if characterState != "idle" {
            characterState = "idle"
            character.removeAllActions()
            startIdleAnimation()
        }
    }
    
    func loadLevel(_ levelData: [String]) {
        let tileSize = CGSize(width: 32, height: 32)
        
        for (rowIndex, row) in levelData.reversed().enumerated() {
            for (colIndex, char) in row.enumerated() {
                let x = CGFloat(colIndex) * tileSize.width
                let y = CGFloat(rowIndex) * tileSize.height
                let position = CGPoint(x: x, y: y)
                
                switch char {
                case "G":
                    let grassBlock = SKSpriteNode(imageNamed: "grass")
                    grassBlock.size = tileSize
                    grassBlock.position = position
                    grassBlock.zPosition = 998
                    grassBlock.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                    grassBlock.physicsBody?.affectedByGravity = false
                    grassBlock.physicsBody?.isDynamic = false
                    grassBlock.physicsBody?.categoryBitMask = PhysicsCategory.ground
                    grassBlock.physicsBody?.collisionBitMask = PhysicsCategory.character
                    addChild(grassBlock)
                    
                case "D":
                    let dirtBlock = SKSpriteNode(imageNamed: "dirt")
                    dirtBlock.size = tileSize
                    dirtBlock.position = position
                    dirtBlock.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                    dirtBlock.physicsBody?.affectedByGravity = false
                    dirtBlock.physicsBody?.isDynamic = false
                    dirtBlock.physicsBody?.categoryBitMask = PhysicsCategory.ground
                    dirtBlock.physicsBody?.collisionBitMask = PhysicsCategory.character
                    addChild(dirtBlock)
                    
                case "L":
                    let lava = SKSpriteNode(imageNamed: "lava")
                    lava.size = tileSize
                    lava.position = position
                    lava.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                    lava.physicsBody?.affectedByGravity = false
                    lava.physicsBody?.isDynamic = false
                    lava.physicsBody?.categoryBitMask = PhysicsCategory.lava
                    lava.physicsBody?.contactTestBitMask = PhysicsCategory.character
                    lava.physicsBody?.collisionBitMask = 0
                    addChild(lava)
                    
                    
                case "P":
                    character.position = position
                    
                default:
                    break
                }
            }
        }
    }
        
        func nextLevel() {
            if currentLevel >= 2 {return}
            
            currentLevel += 1
            switch currentLevel {
            case 2:
                loadLevel(level2)
            default:
                print("No More Levels")
            }
        }
    

}
    #Preview {
        ContentView()
    }
    
