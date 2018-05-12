//
//  GameSprite.swift
//  firstGame
//
//  Created by Joshua on 2018. 5. 5..
//  Copyright © 2018년 Joshua.io. All rights reserved.
//

import SpriteKit

protocol GameSprite{
    var textureAtlas:SKTextureAtlas{get set}
    var initialSize:CGSize{get set}
    func onTap()
}
