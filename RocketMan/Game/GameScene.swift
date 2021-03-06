//
//  GameScene.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 12.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Nodes
    
    var background: BackgroundNode!
    var player: PlayerNode!
    var textOverlayNode: SKSpriteNode?
    
    
    //MARK: - Properties
    
    var playableRect: CGRect!;
    var cameraPlayableRect: CGRect{
        return CGRect(
            x: camera!.position.x - playableRect.size.width/2,
            y: camera!.position.y - playableRect.size.height/2,
            width: playableRect.width,
            height: playableRect.height);
    }
    
    var lastUpdateTime: TimeInterval = 0;
    var dt: TimeInterval = 0;
    var frameCount = 0;
    
    //MARK: Game Logic Properties
    var shouldPause = false //Used in update to fix a bug where game is resumed when reentering active state
    override var isPaused:Bool{
        willSet(newValue){
            if(!newValue){
                lastUpdateTime = 0;
                dt = 0;
            }
        }
    }
    var isGameOver:Bool{
        return isGameWon || isGameLost
    }
    var isGameWon = false
    var isGameLost = false
    
    //Mark: - Enemies Properties
    
    var enemiesTileMap:SKTileMapNode!
    var lastMaxColumnForEnemies: Int = 0
    
    //Mark: - World Properties
    
    var tileMap: SKTileMapNode?
    var tileMapsHealth = [[CGFloat]]() // Keeps track of tile health
    var tileMapSolids = [[Bool]]()
    
    //MARK: - System
    /*
    override init(size: CGSize){
        super.init(size: size);
    }
    */
 
    override func didMove(to view: SKView){
        NotificationCenter.default.addObserver(self, selector: #selector(setShouldPause), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func willMove(from view: SKView) {
        background = nil
        player = nil
        tileMap = nil
        textOverlayNode = nil
        playableRect = nil
        enemiesTileMap = nil
        for node in children{
            node.removeAllActions()
            node.removeFromParent()
        }
        resetDequableNodes()
    }


    func setup(){
        resetDequableNodes()
        preloadDequableNodes()
        addPlayableRect()
        addBackground()
        initWorld()
        addCamera()
        initEnemies()
        addPlayer()
    }
    
    //MARK: - Game update
    
    override func update(_ currentTime: TimeInterval){
        if(shouldPause && isGameWon){ gameWon()}
        else if(shouldPause && isGameLost) {gameLost()}
        else if(shouldPause) {pauseGame()}
        shouldPause = false
        
        if !isPaused{
            //Updates phase before Physics
            updateDt(currentTime)
            if(!isGameOver){
                background.update(to: camera!, sceneWidth: frame.width)
                camera!.update(dt: dt)
                player.update(in: cameraPlayableRect)
            }
        
            //Physics phase
            runPhysics()
            
            if(!isGameOver){
                checkWinCondition()
                checkLooseCondition()
            }
            updateEnemies()
            
            //Cleanup phase, every 60 frames
            if(frameCount >= 60){
                removeNodesOutsideView()
                frameCount = 0
            }
        }
        frameCount += 1
    }
    
    //Calculates the time passed since last frame
    func updateDt(_ currentTime: CFTimeInterval){
        if lastUpdateTime > 0{
            dt = currentTime-lastUpdateTime;
            dt = dt > MAX_DT ? MAX_DT : dt
        }else{
            dt = 0;
        }
        lastUpdateTime = currentTime;
    }
    
    //MARK: - Add Nodes
    
    func addBackground(){
        let background = BackgroundNode(size: size)
        addChild(background)
        self.background = background
    }
    
    func addPlayer(){
        let player = PlayerNode(playableRect: playableRect, playerMargin: PLAYER_MARGIN)
        addChild(player)
        self.player = player
    }
    
    func addCamera(){
        let cam = SKCameraNode(position: CGPoint(x: size.width/2, y: size.height/2))
        camera = cam
        addChild(camera!)
    }
    
    func addPlayableRect(){
        let playableHeight: CGFloat = size.width/MAX_ASPECT_RATIO;
        let playableMargin: CGFloat = (size.height - playableHeight)/2.0;
        playableRect = CGRect(x:0, y:playableMargin, width: size.width, height: playableHeight);
    }
    
    func preloadDequableNodes(){
        PlayerBulletNode.preloadReusableNodes(amount: 8)
        ExplosionFire.preloadReusableNodes(amount: 8)
        ExplosionSmoke.preloadReusableNodes(amount: 8)
        DustBrown.preloadReusableNodes(amount: 8)
        BloodEmitter.preloadReusableNodes(amount: 2)
        MuzzleNode.preloadReusableNodes(amount: 2)
        Zombie.preloadReusableNodes(amount: 8)
        DestroyedTileNode.preloadReusableNodes(amount: 20)
    }
    
    func resetDequableNodes(){
        PlayerBulletNode.resetReusableNodes()
        ExplosionFire.resetReusableNodes()
        ExplosionSmoke.resetReusableNodes()
        DustBrown.resetReusableNodes()
        BloodEmitter.resetReusableNodes()
        MuzzleNode.resetReusableNodes()
        DestroyedTileNode.resetReusableNodes()
        PhysicsNode.resetStaticArrays()
    }
    
    //MARK: - DataStorage
    /*
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
}
