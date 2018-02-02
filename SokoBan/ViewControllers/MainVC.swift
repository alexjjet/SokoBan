//
//  MainVC.swift
//  SokoBan
//
//  Created by Alexandr Kukushkin on 25.01.2018.
//  Copyright © 2018 Alexandr Kukushkin. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    @IBOutlet weak var drawLevelLabel: UILabel!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func upButton(_ sender: UIButton) {
        room.movePlayer(.up)
        updateLabels()
    }
    @IBAction func downButton(_ sender: UIButton) {
        room.movePlayer(.down)
        updateLabels()
    }
    @IBAction func rightButton(_ sender: UIButton) {
        room.movePlayer(.right)
        updateLabels()
    }
    @IBAction func leftButton(_ sender: UIButton) {
        room.movePlayer(.left)
        updateLabels()
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        startNewRound()
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewRound()
        updateLabels()
        
    }
    
    var room = Model.Room()
    
    func updateLabels() {
        drawLevelLabel.text = room.draw()
        stepsLabel.text = String(moves)
        levelLabel.text = String(level)
        displayLabel.isHidden = !room.win()
        
        if room.win() && (level < arrLevels.count) {
            level += 1
            room = Model.Room()
            startNewRound()
        }
        else {
            level = 0
        }
    }
    
    func startNewRound() {
        moves = 0
        room.reset(width: arrLevels[level].contentX, height: arrLevels[level].content.count / arrLevels[level].contentX)
        
        for (i, j) in arrLevels[level].content.enumerated() {
            let x = i % arrLevels[level].contentX
            let y = i / arrLevels[level].contentX
            
            switch j {
            case "w": room.addWall(.init(x: x, y: y))
            case "b": room.addBox(.init(x: x, y: y))
            case "t": room.addTarget(.init(x: x, y: y))
            case "p": room.setPlayer(.init(x: x, y: y))
            default: break
            }
        }
    }
}

