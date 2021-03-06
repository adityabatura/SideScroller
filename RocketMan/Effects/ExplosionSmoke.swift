//
//  ExplosionSmoke.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 01.04.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

class ExplosionSmoke{
    
    static let waitAction = SKAction.wait(forDuration: 0.4)
    static let alphaAction = SKAction.fadeAlpha(to: 0, duration: 1)
    
    
    static func runAction(node: SKEmitterNode){
        let removeAction = SKAction.customAction(withDuration: 0){_,_ in ExplosionSmoke.removeNode(node: node)}
        let sequenceAction = SKAction.sequence([waitAction,alphaAction,removeAction])
        node.run(sequenceAction)
    }
    
    //MARK: - Reusable Nodes
    
    private static var _reusableNodes = ReusableNodes<SKEmitterNode>(label: "ExplosionSmokeNodeQueue")
    
    static func resetReusableNodes(){
        _reusableNodes.reset()
    }
    
    static func dequeReusableNode() -> SKEmitterNode?{
        var node: SKEmitterNode? = _reusableNodes.deque()
        if(node == nil || node!.parent != nil){
            node = SKEmitterNode(fileNamed: "ExplosionSmoke.sks")
        }
        node?.resetSimulation()
        node?.isPaused = false
        node?.alpha = 1
        if(node != nil){
            ExplosionSmoke.runAction(node: node!)
        }
        return node
    }
    
    static func queueReusableNode(_ node: SKEmitterNode){
        node.removeAllActions()
        _reusableNodes.queue(node)
    }
    
    static func preloadReusableNodes(amount: Int){
        for _ in 0..<amount{
            if let node = SKEmitterNode(fileNamed: "ExplosionSmoke.sks"){
                node.isPaused = true
                node.resetSimulation()
                queueReusableNode(node)
            }
        }
    }
    
    static func removeNode(node: SKEmitterNode){
        ExplosionSmoke.queueReusableNode(node)
        node.removeFromParent()
    }
}
