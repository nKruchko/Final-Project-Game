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
    var lvl1 = true
    var lvl2 = true
    var lvl3 = true
    var lvl4 = true
    var lvl5 = true
    var lvl6 = true
    var winLabel = SKLabelNode(text: "You Win")
    var startLabel = SKLabelNode(text: "Collect the sunflowers")
    
    let level1 = [
        "             ",
        "             ",
        "             ",
        "             ",
        "           S ",
        "          GGG",
        " P   GGG     ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level2 = [
        "             ",
        "             ",
        "             ",
        "           S ",
        "           G ",
        "             ",
        "             ",
        "        G    ",
        "             ",
        "             ",
        "     G       ",
        "             ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level3 = [
        "         S   ",
        "         G   ",
        "             ",
        "             ",
        "     G       ",
        "             ",
        "             ",
        " G           ",
        "             ",
        "             ",
        "     G       ",
        "             ",
        "GGG          ",
        "             ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level4 = [
        "             ",
        "             ",
        "             ",
        "             ",
        "     G       ",
        "             ",
        "        L    ",
        " G      L    ",
        "        L    ",
        "        L    ",
        "     G  L    ",
        "        L    ",
        "GGG     L  S ",
        "        L  G ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level5 = [
        "      P      ",
        "     GGG     ",
        "     LLL     ",
        "GGG L        ",
        "   L         ",
        "   L         ",
        "   L         ",
        "   L   S     ",
        "   L   G     ",
        "LLLLLLLLLLLLL",
        
        
    ]
    
    let level6 = [
        "          S  ",
        "          G  ",
        "   S         ",
        "   G         ",
        "             ",
        "             ",
        "      S      ",
        "      G      ",
        "             ",
        "        S    ",
        "        G    ",
        "             ",
        " S           ",
        " G           ",
        "             ",
        "             ",
        "             ",
        "S S S   S S S",
        "GGGGGGGGGGGGG",
        "DDDDDDDDDDDDD",
        
        
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
        SeedText.text = "\(numOfSeeds)"
        SeedText.fontName = "Courier-Bold"
        
        
        winLabel = SKLabelNode(text: "You win")
        winLabel.position = CGPoint(x: 200, y: 350)
        winLabel.fontSize = 100
        winLabel.fontColor = .green
        winLabel.fontName = "MarkerFelt"
        
        startLabel = SKLabelNode(text: "Collect the Sunflowers")
        startLabel.position = CGPoint(x: 200, y: 200)
        startLabel.fontSize = 30
        startLabel.fontColor = .green
        startLabel.fontName = "MarkerFelt"
        
        
        addChild(startLabel)
        addChild(SeedText)
        addChild(ground)
        
        
        
    }
    var cloudTextures: [SKTexture] = []
    override func didMove(to view: SKView) {
       
        
        cloudTextures = [
            SKTexture(imageNamed: "Cloud_1"),
            SKTexture(imageNamed: "Cloud_2"),
            SKTexture(imageNamed: "Cloud_3"),
            SKTexture(imageNamed: "Cloud_4"),
            SKTexture(imageNamed: "Cloud_4"),
            SKTexture(imageNamed: "Cloud_4"),

        ]
        
        let spawnCloud = SKAction.run{
            let texture = self.cloudTextures.randomElement()!
            let cloud = SKSpriteNode(texture: texture)
            cloud.size.width = (cloud.size.width/5)*CGFloat.random(in: 0.8...1.5)
            cloud.size.height = (cloud.size.height/5)*CGFloat.random(in: 0.8...1.5)
            cloud.zPosition = -100
            
            let startX = -cloud.size.width
            let maxY = CGFloat(500)
            let randomY = self.size.height-CGFloat.random(in: 0...maxY)
            
            cloud.position = CGPoint(x: startX, y: randomY)
            self.addChild(cloud)
            let distance = self.size.width + cloud.size.width * 2
            let speed = CGFloat.random(in: 20...50)
            let duration = TimeInterval(distance / speed)
            
            let move = SKAction.moveBy(x: distance, y: CGFloat(Float.random(in: -100...100)), duration: duration)
            let remove = SKAction.removeFromParent()
            cloud.run(SKAction.sequence([move, remove]))
            if cloud.size.height < 10{
                cloud.speed = cloud.speed*5
                cloud.size.width = cloud.size.width*10
                cloud.size.height = cloud.size.height*10

            }
        }
        
        let wait = SKAction.wait(forDuration: 1.0, withRange: 1.0)
        let sequence = SKAction.sequence([spawnCloud, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)

        //numOfSeeds = 3
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
        
        
        lastPosition = character.position
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if(numOfSeeds == 0) {
            if(lvl1 == true) {
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level1)
                lvl1 = false
            }
        }
        if(numOfSeeds == 1) {
            if(lvl2 == true) {
                startLabel.removeFromParent()
                clearLevel()
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level2)
                SeedText.text = "\(numOfSeeds)"
                lvl2 = false
            }
        }
        if(numOfSeeds == 2) {
            if(lvl3 == true) {
                clearLevel()
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level3)
                SeedText.text = "\(numOfSeeds)"
                lvl3 = false
            }
        }

        if(numOfSeeds == 3) {
            if(lvl4 == true) {
                clearLevel()
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level4)
                SeedText.text = "\(numOfSeeds)"
                lvl4 = false
            }
        }

        if(numOfSeeds == 4) {
            if(lvl5 == true) {
                clearLevel()
                character.run(SKAction.move(to: CGPoint(x: 40, y: 250), duration: 0.01))
                loadLevel(level5)
                SeedText.text = "\(numOfSeeds)"
                lvl5 = false
            }
        }
        if(numOfSeeds == 5) {
            if(lvl6 == true) {
                clearLevel()
                character.run(SKAction.move(to: CGPoint(x: 200, y: 125), duration: 0.01))
                loadLevel(level6)
                SeedText.text = "\(numOfSeeds)"
                lvl6 = false
                addChild(winLabel)
            }
        }
        
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
        
        if firstBody.categoryBitMask == PhysicsCategory.character &&
            secondBody.categoryBitMask == PhysicsCategory.plant {
            numOfSeeds += 1
            plant.removeFromParent()
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
        if(numOfSeeds != 4) {
            character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
        }
        else {
            character.run(SKAction.move(to: CGPoint(x: 40, y: 250), duration: 0.01))

        }
        run(SKAction.playSoundFileNamed("FarmerDeath", waitForCompletion: false))
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
                let plantPosition = CGPoint(x: x, y: y)
                
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
                    grassBlock.name = "levelNode"
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
                    dirtBlock.name = "levelNode"
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
                    lava.name = "levelNode"
                    addChild(lava)
                
                case "S":
                    plant = SKSpriteNode(texture: growFrames[0])
                    plant.size = tileSize
                    plant.position = plantPosition
        
                    plant.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 32))
                    plant.physicsBody?.collisionBitMask = PhysicsCategory.ground
                    plant.physicsBody?.contactTestBitMask = PhysicsCategory.character
                    plant.physicsBody?.categoryBitMask = PhysicsCategory.plant
                    plant.physicsBody?.allowsRotation = false
                    plant.physicsBody?.affectedByGravity = true
                    plant.physicsBody?.restitution = 0.0
                    plant.run((SKAction.animate(with: growFrames, timePerFrame: 1)), withKey: "grow")
                    addChild(plant)
                    
                    
                case "P":
                    character.position = position
                    
                case "M":
                    SeedPickUP = SKSpriteNode(imageNamed: "Seed")
                    SeedPickUP.size = CGSize(width: 45, height: 45)
                    SeedPickUP.position = position
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
                    
                default:
                    break
                }
            }
        }
    }
    func clearLevel() {
        for child in children {
            if child.name == "levelNode" {
                child.removeFromParent()
            }
        }
    }
    
    
    
        func nextLevel() {
          //  if currentLevel >= 5 {return}
            print(currentLevel)
            clearLevel()
           // switch currentLevel {
            if currentLevel == 1 {
                currentLevel += 1
            }
            if currentLevel == 2 {
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level2)
                print("Level 2")
                currentLevel += 1

            }
            if currentLevel == 3 {
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level3)
                print("Level 3")
                currentLevel += 1

            }
            if currentLevel == 4 {
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level4)
                print("Level 4")
                currentLevel += 1

            }
            if currentLevel == 5 {
                character.run(SKAction.move(to: CGPoint(x: 40, y: 125), duration: 0.01))
                loadLevel(level5)
                print("Level 5")
                currentLevel += 1

            }
            if currentLevel == 6 {
                character.run(SKAction.move(to: CGPoint(x: 200, y: 125), duration: 0.01))
                loadLevel(level6)
                print("Level 6")
            }
            else {
                print("No More Levels")
            }
           // }
        }

}
    #Preview {
        ContentView()
    }
    
//let level1 = [
//    "             ",
//    "             ",
//    "             ",
//    "             ",
//    "           S ",
//    "          GGG",
//    " P   GGG  DDD ",
//    "GGG  DDD   D ",
//    "DDD   D      ",
//    "LLLLLLLLLLLLL",
//    
//    
//]
//
//let level2 = [
//    "             ",
//    "             ",
//    "             ",
//    "           S ",
//    "           G ",
//    "           D ",
//    "           D ",
//    "        G  D ",
//    "        D  D ",
//    "        D  D ",
//    "     G  D  D ",
//    "     D  D  D ",
//    "GGG  D  D  D ",
//    "DDDLLDLLDLLDL",
//    "LLLLLLLLLLLLL",
//    
//    
//]
//
//let level3 = [
//    "         S   ",
//    "         G   ",
//    "        DDD  ",
//    "       GDDDG ",
//    "     GGDDDDDG",
//    "         DDDD",
//    "         DDDD",
//    "GG       DDDD",
//    "D        DDDD",
//    "       GGDDDD",
//    "     GGDDDDDD",
//    "       DDDDDD",
//    "GGG     DDDDD",
//    "DDLLLLLLDDDDD",
//    "LLLLLLLLLLLLL",
//    
//    
//]
//
//let level4 = [
//    "             ",
//    "             ",
//    "             ",
//    "             ",
//    "     G       ",
//    "             ",
//    "             ",
//    " G           ",
//    "             ",
//    "             ",
//    "     G       ",
//    "             ",
//    "GGG        S ",
//    "           G ",
//    "LLLLLLLLLLLLL",
//    
//    
//]
//
//let level5 = [
//    "      P      ",
//    "     GGG     ",
//    "             ",
//    "GGG          ",
//    "             ",
//    "             ",
//    "             ",
//    "      S      ",
//    "      G      ",
//    "LLLLLLLLLLLLL",
//    
//    
//]
