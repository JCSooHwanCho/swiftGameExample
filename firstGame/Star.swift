//
//  Star.swift
//  firstGame
//
//  Created by SooHwan.Cho on 2018. 5. 7..
//  Copyright © 2018년 Joshua.io. All rights reserved.
//

import SpriteKit

class Star:SKSpriteNode, GameSprite{
    var initialSize = CGSize(width:40, height:38)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var pulseAnimation = SKAction()
    
    init(){
        let starTexture = textureAtlas.textureNamed("star")
        super.init(texture: starTexture, color: .clear, size:initialSize)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        createAnimations()
        self.run(pulseAnimation)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
    }
    
    func createAnimations(){
        
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85,duration:0.8),
            SKAction.scale(to:0.6, duration:0.8),
            SKAction.rotate(byAngle:-0.3, duration:0.8)
            ])
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to:1,duration:1.5),
            SKAction.scale(to: 1.0, duration: 1.5),
            SKAction.rotate(byAngle: 0.5, duration: 1.5)
            ])
        
        let pulseSequence = SKAction.sequence([pulseOutGroup,pulseInGroup])
        pulseAnimation = SKAction.repeatForever(pulseSequence)
    }
    func getStar(){
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
            self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
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
