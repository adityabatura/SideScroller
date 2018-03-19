//
//  Constants.swift
//  RocketMan
//
//  Created by Patrick Henriksen on 13.03.2018.
//  Copyright © 2018 Patrick Henriksen. All rights reserved.
//

import SpriteKit

//MARK: SYSTEM CONSTANTS

let MAX_ASPECT_RATIO:CGFloat = 16.0/9.0 //Max aspect ration for the used devices

//WORLD CONSTANTS

let GRAVITY: CGFloat = -800
let CAMERA_VELOCITY: CGFloat = 400
let TILE_SIZE:CGFloat = 64 //Standard tile size
let REMOVE_NODES_DISTANCE: CGFloat = 500 //Removes nodes when they are this distance outside viewable screen

//TOUCH CONSTANTS

// Splits the screen in two parts where a touch at a position further left than LEFT_SCREEM_AMOUNT * screen width
// is considered as a touch on the left screen
let LEFT_SCREEN_AMOUNT: CGFloat = 0.3


//PLAYER CONSTANTS
let PLAYER_SIZE = CGSize(width: 180, height: 180)
let PLAYER_MARGIN: CGFloat = 250 //The default distance to the left camera corner
let PLAYER_VELOCITY_OFF_MARGIN_MUL: CGFloat = 0.3 //Velocity increase/decrease if the player is off margin
let PLAYER_PHYSICS_FRAME_SCALE = CGPoint(x: 0.4, y: 0.8)

let PLAYER_JUMP_SPEED: CGFloat = 800
let STANDARD_TIME_PER_FRAME:TimeInterval = 0.05
let SHOOTING_TIME_PER_FRAME:TimeInterval = 0.1

let PLAYER_MUZZLE_POSITION = CGPoint(x: 0.87, y: 0.5)

let PLAYER_BULLET_SIZE = CGSize(width: 50, height: 50)
let PLAYER_BULLET_PHYSICS_FRAME_SCALE = CGPoint(x: 0.8, y: 0.8)
let PLAYER_BULLET_SPEED: CGFloat = 1500

//The time used to scale the bullet from 0 to bullet size when fired
let PLAYER_BULLET_SCALE_DURATION:TimeInterval = 0.2

// The bullet starts at player.position + player.size * PLAYER_BULLET_START_POSITION
let PLAYER_BULLET_START_POSITION = CGPoint(x: PLAYER_MUZZLE_POSITION.x - 0.15, y: PLAYER_MUZZLE_POSITION.y)
