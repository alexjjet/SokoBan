//
//  Model.swift
//  SokoBan
//
//  Created by Alexandr Kukushkin on 01.02.2018.
//  Copyright © 2018 Alexandr Kukushkin. All rights reserved.
//

import UIKit

var level = 0
var moves = 0

let level0Content = "wwwwwwwwwwwp000000tww00000000ww00000000ww0000b000ww00000000ww00000000ww00000000ww00000000wwwwwwwwwww"
let level0X = 10

let level1Content = "wwwwwwwwwwwpt000t00ww00www000ww00000000wwww00b000ww00000bb0ww00000000ww00ww0000ww0000t000wwwwwwwwwww"
let level1X = 10

let tupleLevel0 = (content: level0Content, contentX: level0X)
let tupleLevel1 = (content: level1Content, contentX: level1X)
let arrLevels = [tupleLevel0, tupleLevel1]

class Model: NSObject {
    
    enum Direction {
        case up, down, left, right
    }
    
    struct Player {
        var x: Int, y: Int
        
        mutating func moveBy(_ dir: Direction) {
            switch dir {
            case .up: y -= 1
            case .down: y += 1
            case .left: x -= 1
            case .right: x += 1
            }
            moves += 1
        }
    }
    
    struct Box {
        var x: Int, y: Int
        
        mutating func moveBy(_ dir: Direction) {
            switch dir {
            case .up: y -= 1
            case .down: y += 1
            case .left: x -= 1
            case .right: x += 1
            }
        }
    }
    
    struct Target {
        var x: Int, y: Int
    }
    
    struct Wall {
        var x: Int, y: Int
    }
    
    class Room {
        var width: Int, height: Int
        
        var player = Player(x: 0, y: 0)
        var boxes: [Box]
        var targets: [Target]
        var walls: [Wall]
        
        init() {
            self.width = 0
            self.height = 0
            self.boxes = [Box]()
            self.targets = [Target]()
            self.walls = [Wall]()
        }
        
        func setPlayer(_ newPlayer: Player) {
            self.player = newPlayer
        }
        
        func addBox(_ newBox: Box) {
            boxes.append(newBox)
        }
        
        func addTarget(_ newTarget: Target) {
            targets.append(newTarget)
        }
        
        func addWall(_ newWal: Wall) {
            walls.append(newWal)
        }
        
        func draw() -> String {
            var board = ""
            var floor: Bool
            
            for i in 0..<height {
                for j in 0..<width {
                    
                    floor = true
                    
                    if player.x == j && player.y == i {
                        board += "\u{1F604}"
                        floor = false
                    }
                    for box in boxes {
                        if floor && box.x == j && box.y == i {
                            board += "\u{1F4E6}"
                            floor = false
                            break
                        }
                    }
                    for wall in walls {
                        if floor && wall.x == j && wall.y == i {
                            board += "\u{25FE}"
                            floor = false
                            break
                        }
                    }
                    for target in targets {
                        if floor && target.x == j && target.y == i {
                            board += "\u{1F3C1}"
                            floor = false
                            break
                        }
                    }
                    if floor {
                        board += "\u{25FD}"
                    }
                }
                board += "\n"
            }
            return board
        }
        
        func reset (width: Int, height: Int) {
            self.width = width
            self.height = height
            self.player = Player(x: 0, y: 0)
            self.boxes = [Box]()
            self.targets = [Target]()
            self.walls = [Wall]()
        }
        
        func movePlayer(_ dir: Direction) {
            
            var nextBox : Int? = nil
            var nextWall : Int? = nil
            var secondBox : Int? = nil
            var secondWall : Int? = nil
            var xK = 0
            var yK = 0
            
            switch dir {
            case .left:  xK = -1
            case .right: xK = 1
            case .down:  yK = 1
            case .up:    yK = -1
            }
            
            for i in 0..<boxes.count {
                if boxes[i].x == player.x + xK && boxes[i].y == player.y + yK {
                    nextBox = i
                }
                if boxes[i].x == player.x + xK * 2  && boxes[i].y == player.y + yK * 2 {
                    secondBox = i
                }
            }
            for i in 0..<walls.count {
                if walls[i].x == player.x + xK && walls[i].y == player.y + yK {
                    nextWall = i
                }
                if walls[i].x == player.x + xK * 2 && walls[i].y == player.y + yK * 2 {
                    secondWall = i
                }
            }
            if nextBox != nil && (secondBox == nil && secondWall == nil) {
                boxes[nextBox!].moveBy(dir)
                player.moveBy(dir)
            }
            else if nextBox == nil && nextWall == nil {
                player.moveBy(dir)
            }
        }
        
        func win() -> Bool {
            var count = 0
            for box in boxes {
                for target in targets {
                    count += box.x == target.x && box.y == target.y ? 1 : 0
                }
            }
            return count == targets.count
        }
    }

}














