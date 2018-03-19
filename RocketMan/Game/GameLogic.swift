//
//  GameLogic.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 15.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    //MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        if(touchLocation.x < cameraPlayableRect.minX + LEFT_SCREEN_AMOUNT*cameraPlayableRect.width){
            player.jump()
        }
        else{
            playerFire(at: touch.location(in: self))
        }
    }
    
    func playerFire(at touchLocation: CGPoint){
        let bullet = player.fire()
        if(bullet != nil){
            let bulletDirection = (touchLocation - player.centerPosition()).normalized()
            bullet?.velocity = bulletDirection * PLAYER_BULLET_SPEED
            bullet?.zRotation = atan2(bulletDirection.y, bulletDirection.x)
            addChild(bullet!)
        }
    }
}
