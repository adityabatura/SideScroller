//
//  Physics.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 14.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

enum Direction{
    case Up, Down, Left, Right
}

extension GameScene{
    
    //Runs the physics loop
    func runPhysics(){
        willUpdatePhysicNodes()
        applyGravity()
        applyRotation()
        moveNodes()
        checkNodeWithNodeCollision()
        resolveNodeWithNodeCollisions()
        didUpdatePhysicNodes()
    }
    
    //Calls the willUpdatePhysics() methode in each node
    func willUpdatePhysicNodes(){
        /*
         * Looping through the children instead of PhysicsNode.getAllNodes() since the node won't be added to allNodes
         * until willUpdatePhysics is called
         */
        for child in children{
            guard let node = child as? PhysicsNode else {continue}
            node.willUpdatePhysics()
        }
    }
    
    //Calls the didUpdatePhysics() methode in each node
    func didUpdatePhysicNodes(){
        for node in PhysicsNode.getAllNodes(){
            node.didUpdatePhysics()
        }
    }
    
    func applyGravity(){
        for node in PhysicsNode.getNodesAffectedByGravity(){
            node.velocity.y += GRAVITY * CGFloat(dt) * node.gravitationMultiplier
        }
    }
    
    func applyRotation(){
        for node in PhysicsNode.getAllNodes(){
            if node.continuesRotationTime > 0{
                node.zRotation += node.continuesRotationAngle*CGFloat(dt)
                node.continuesRotationTime -= dt
            }
        }
    }
    
    //Applies gravity acceleration and moves the nodes acording to node velocity and dt
    func moveNodes(){
        for node in PhysicsNode.getAllNodes(){
            var movement = node.velocity*CGFloat(dt)
            if(node.isAffectedByWorldSolids){
                movement = adjustMovementForCollisionWithWorld(for: node, with: movement)
            }
            node.position += movement
        }
    }
    
    func adjustMovementForCollisionWithWorld(for node: PhysicsNode, with movement: CGPoint) -> CGPoint{
        guard movement != CGPoint.zero else {return movement}
        
        //Calcluate number of steps so each step is maximum 1 point
        let numSteps = (Int(ceil(max(abs(movement.x), abs(movement.y)))))
        let movementStep = movement/CGFloat(numSteps)
        
        var adjustedMovement = CGPoint.zero
        var hasHitSolidYDirection = false
        var hasHitSolidXDirection = false
        
        let directionX:Direction = movement.x < 0 ? .Left : .Right
        let directionY:Direction = movement.y < 0 ? .Down : .Up
        
        let pointsToCheckX = directionX == .Left ? node.getLeftSensorPoints() : node.getRightSensorPoints();
        let pointsToCheckY = directionY == .Down ? node.getBottomSensorPoints() : node.getTopSensorPoints();
        
        for _ in 0..<numSteps{
            if(!hasHitSolidYDirection){
                adjustedMovement.y += movementStep.y
                for point in pointsToCheckY{
                    if hasSolidObject(at: point + adjustedMovement){
                        nodeHitWorld(node, at: point + adjustedMovement, direction: directionY)
                        adjustedMovement.y -= movementStep.y
                        if(directionY == .Down){adjustedMovement.y = ceil(adjustedMovement.y)}
                        else{adjustedMovement.y = floor(adjustedMovement.y)}
                        hasHitSolidYDirection = true
                        break
                    }
                }
            }
            
            if(!hasHitSolidXDirection){
                adjustedMovement.x += movementStep.x
                for point in pointsToCheckX{
                    if hasSolidObject(at: point + adjustedMovement){
                        nodeHitWorld(node, at: point + adjustedMovement, direction: directionX)
                        adjustedMovement.x -= movementStep.x
                        if(directionX == .Left){adjustedMovement.x = ceil(adjustedMovement.x)}
                        else{adjustedMovement.x = floor(adjustedMovement.x)}
                        hasHitSolidXDirection = true
                        break
                    }
                }
            }
        }
        return adjustedMovement
    }
    
    func nodeHitWorld(_ node: PhysicsNode, at point: CGPoint, direction: Direction){
        if(direction == .Up){node.hitSolidRoof(at: point)}
        else if(direction == .Down){node.hitSolidGround(at: point)}
        else if(direction == .Right){node.hitSolidRight(at: point)}
        else if(direction == .Left){node.hitSolidLeft(at: point)}
    }
    
    //Checks all physicsNodes for node with node collision
    func checkNodeWithNodeCollision(){
        var currentIndex = 0;
        for node1 in PhysicsNode.getNodesAffectedByPhysicNodes(){
            currentIndex += 1
            for i in currentIndex..<PhysicsNode.getNodesAffectedByPhysicNodes().count{
                let node2 = PhysicsNode.getNodesAffectedByPhysicNodes()[i]
                guard node1 != node2 else {continue}
                if(node1.physicsFrame.intersects(node2.physicsFrame)){
                    node1.collidingNodes.append(node2)
                }
            }
        }
    }
    
    //Notifies the PhysicsNodes of collisions stored in the nodes collidingNodes array
    func resolveNodeWithNodeCollisions(){
        for node1 in PhysicsNode.getNodesAffectedByPhysicNodes(){
            for node2 in node1.collidingNodes{
                node1.collided(with: node2)
                node2.collided(with: node1)
            }
            node1.collidingNodes = [PhysicsNode]()
        }
    }
    
    //Returns all physicsNodes colliding with the given rect
    func getPhysicNodesColliding(with rect: CGRect) -> [PhysicsNode]{
        var collidingNodes = [PhysicsNode]()
        for node in PhysicsNode.getNodesAffectedByPhysicNodes(){
            if(rect.intersects(node.physicsFrame)){
                collidingNodes.append(node)
            }
        }
        return collidingNodes
    }
}
