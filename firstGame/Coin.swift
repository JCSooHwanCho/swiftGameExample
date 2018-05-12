//
//  Coin.swift
//  firstGame
//
//  Created by SooHwan.Cho on 2018. 5. 7..
//  Copyright © 2018년 Joshua.io. All rights reserved.
//

import SpriteKit

class Coin:SKSpriteNode,GameSprite{
    
    var initialSize = CGSize(width: 26, height: 26)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var value = 1
    
    init(){
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture:bronzeTexture,color:.clear, size:initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    func turnToGold(){
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func collect(){
        self.physicsBody?.categoryBitMask = 0
       
        let collectAnimation = SKAction.group([
            SKAction.fadeAlpha(to: 0, duration: 0.2),
            SKAction.scale(to:1.5,duration: 0.2),
            SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2)])
        
        let resetAfterCollected = SKAction.run{
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        
        let collectSequence = SKAction.sequence([
            collectAnimation,resetAfterCollected])
        
        self.run(collectSequence)
    }
    func onTap(){}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

