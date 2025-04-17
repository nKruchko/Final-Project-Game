//
//  GameScene.swift
//  Final Project Game
//
//  Created by Laporionok, Rostislav (513077) on 4/17/25.
//

import SpriteKit





class GameScene: SKScene {

    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var background3: SKSpriteNode!  // 👈 new panel

    override func didMove(to view: SKView) {
        backgroundColor = .cyan
        anchorPoint = .zero

        setupBackground()
        //createWorld()
        //createPlayer()
    }

    func setupBackground() {
        let skyTexture = SKTexture(imageNamed: "clouds")

        let textureWidth = skyTexture.size().width
        let textureHeight = size.height

        background1 = SKSpriteNode(texture: skyTexture)
        background2 = SKSpriteNode(texture: skyTexture)
        background3 = SKSpriteNode(texture: skyTexture)  // 👈 create third background

        for bg in [background1, background2, background3] {
            bg?.anchorPoint = .zero
            bg?.size = CGSize(width: textureWidth, height: textureHeight)
            bg?.zPosition = -10
        }

        background1.position = CGPoint(x: 0, y: 0)
        background2.position = CGPoint(x: textureWidth, y: 0)
        background3.position = CGPoint(x: -textureWidth, y: 0) // 👈 to the left

        addChild(background1)
        addChild(background2)
        addChild(background3)
    }

    override func update(_ currentTime: TimeInterval) {
        scrollBackground()
    }

    func scrollBackground() {
        let scrollSpeed: CGFloat = 0.5

        background1.position.x += scrollSpeed
        background2.position.x += scrollSpeed
        background3.position.x += scrollSpeed

        let textureWidth = background1.size.width

        // Loop backgrounds when fully off the right side of screen
        if background1.position.x >= size.width {
            background1.position.x = min(background2.position.x, background3.position.x) - textureWidth
        }

        if background2.position.x >= size.width {
            background2.position.x = min(background1.position.x, background3.position.x) - textureWidth
        }

        if background3.position.x >= size.width {
            background3.position.x = min(background1.position.x, background2.position.x) - textureWidth
        }
    }
}
