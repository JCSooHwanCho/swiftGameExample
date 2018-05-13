//
//  Background.swift
//  firstGame
//
//  Created by SooHwan.Cho on 2018. 5. 13..
//  Copyright © 2018년 Joshua.io. All rights reserved.
//

import SpriteKit

class Background:SKSpriteNode{
    
    var movementMultiplier = CGFloat(0)
    
    var jumpAdjustmet = CGFloat(0)
    
    let backgroundSize = CGSize(width:1024,height:768)
    
    var textureAtlas = SKTextureAtlas(named:"Backgrounds")
    
    func Spawn(parentNode:SKNode, imageName:String, zPosition:CGFloat,movementMultiplier:CGFloat){
        self.anchorPoint = CGPoint.zero
        self.position = CGPoint(x: 0, y: 30)
        self.zPosition = zPosition
        
        self.movementMultiplier = movementMultiplier
        
        parentNode.addChild(self)
        
        let texture = textureAtlas.textureNamed(imageName)
        
        for i in -1...1{
            let newBGNode = SKSpriteNode(texture: texture)
            
            newBGNode.anchorPoint = CGPoint.zero
            newBGNode.position = CGPoint(x:i*Int(backgroundSize.width),y:0)
            
            self.addChild(newBGNode)
        }
    }
    
    func updatePosition(playerProgress:CGFloat){
        let adjustedPosition = jumpAdjustmet + playerProgress*(1-movementMultiplier)
        
        if playerProgress - adjustedPosition > backgroundSize.width{
            jumpAdjustmet += backgroundSize.width
        }
        self.position.x = adjustedPosition
    }
}
