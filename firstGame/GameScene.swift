//
//  GameScene.swift
//  firstGame
//
//  Created by Joshua on 2018. 5. 3..
//  Copyright © 2018년 Joshua.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private let cam = SKCameraNode()
    private let player = Player()
    private let ground = Ground()
    private var screenCenterY = CGFloat()
    let initialPlayerPosition = CGPoint(x:150, y: 250)
    var playerProgress = CGFloat()
    let encounterManager = EncounterManager()
    let powerUpStar = Star()
    let hud = HUD()
    var nextEncounterSpawnPosition = CGFloat(150)
    var backgrounds:[Background] = []
    var coinsCollected = 0
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4,green: 0.6, blue: 0.95, alpha: 1.0)
        
        self.camera = cam
 
        player.position = initialPlayerPosition
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx:0,dy: -5)
        
        screenCenterY = self.size.height / 2
        
        encounterManager.addEncountersToScene(gameScene: self)
        
        encounterManager.encounters[0].position = CGPoint(x:400, y:300)
        
        self.addChild(powerUpStar)
        
        powerUpStar.position = CGPoint(x: -2000,y:-2000)
        
        ground.position = CGPoint(x: -self.size.width * 2,y: 150)
        ground.size = CGSize(width: self.size.width*6,height: 0)
        
        ground.createChildren()
        
        self.addChild(ground)
        
        self.addChild(self.camera!)
        
        self.camera!.zPosition = 50
        
        hud.createHudNodes(screenSize: self.size)
        
        self.camera!.addChild(hud)
        
        for _ in 0..<3{
            backgrounds.append(Background())
        }
        
        backgrounds[0].Spawn(parentNode: self, imageName: "background-front", zPosition: -5, movementMultiplier: 0.75)
        backgrounds[1].Spawn(parentNode: self, imageName: "background-middle", zPosition: -10, movementMultiplier: 0.5)
        backgrounds[2].Spawn(parentNode: self, imageName: "background-back", zPosition: -15, movementMultiplier: 0.2)
        
        if let dotEmitter = SKEmitterNode(fileNamed: "PierrePath"){
            player.zPosition = 10
            dotEmitter.particleZPosition = -1
            player.addChild(dotEmitter)
            dotEmitter.targetNode = self
        }
        self.run(SKAction.playSoundFileNamed("Sound/StartGame.aif", waitForCompletion: false))
    }
    
    override func didSimulatePhysics() {
        var cameraYPos = screenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        playerProgress = player.position.x - initialPlayerPosition.x
        if(player.position.y>screenCenterY){
            cameraYPos = player.position.y
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
        }
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
        ground.checkForReposition(playerProgress:playerProgress)
        
        if player.position.x > nextEncounterSpawnPosition{
            encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
        }
        let starRoll = Int(arc4random_uniform(10))
        if starRoll == 0{
            if abs(player.position.x - powerUpStar.position.x) > 1200{
                let randomYPos = 50 + CGFloat(arc4random_uniform(400))
                powerUpStar.position = CGPoint(x:nextEncounterSpawnPosition,y:randomYPos)
                powerUpStar.physicsBody?.angularVelocity = 0
                powerUpStar.physicsBody?.velocity = CGVector(dx:0,dy:0)
            }
        }
        for background in self.backgrounds{
            background.updatePosition(playerProgress: playerProgress)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in:self)
            let nodeTouched = atPoint(location)
            if let gameSprite = nodeTouched as? GameSprite{
                gameSprite.onTap()
            }
            
            if nodeTouched.name == "restartGame"{
                self.view?.presentScene(GameScene(size: self.size),transition: .crossFade(withDuration: 0.6))
            }
            else if nodeTouched.name == "returnToMenu"{
                self.view?.presentScene(MenuScene(size:self.size), transition: .crossFade(withDuration: 0.6))
            }
        }
        player.startFlapping()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    override func update(_ currentTime:TimeInterval){
        player.update()
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let otherBody:SKPhysicsBody
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        
        if((contact.bodyA.categoryBitMask & penguinMask)>0){
            otherBody = contact.bodyB
        }
        else{
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask{
            case PhysicsCategory.ground.rawValue:
                player.takeDamage()
                hud.setHealthDisplay(newHealth: player.health)
            case PhysicsCategory.enemy.rawValue:
                player.takeDamage()
                hud.setHealthDisplay(newHealth: player.health)
            case PhysicsCategory.coin.rawValue:
                if let coin = otherBody.node as? Coin{
                    coin.collect()
                    self.coinsCollected += coin.value
                    hud.setCoinCountDisplay(newCoinCount: self.coinsCollected)
            }
            case PhysicsCategory.powerup.rawValue:
                powerUpStar.getStar()
                player.starPower()
            default:
                print("contact with no game logic")
        }
    }
    func gameOver(){
        hud.showButtons()
    }
}
