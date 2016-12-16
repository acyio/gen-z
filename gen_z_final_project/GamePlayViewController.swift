//
//  GamePlayViewController.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 11/8/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//


import Foundation
import CoreData
import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GamePlayViewController: UIViewController {

    var timer1: Timer!
    var playerName: String!
    var savedSuccess: Bool = false
    
   // @IBOutlet weak var mainCharShip: UIImageView!
    @IBOutlet weak var deadButton: CustomButtonView!
    @IBOutlet weak var gameOver: UILabel!
    var shipImage: String!

    let scene = GameScene(fileNamed: "GameScene")
    
    var anchorPoint : CGPoint = CGPoint(x:0.0,y:0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkGameEnd), userInfo: nil, repeats: true)
        
        scene?.imageOfShip = shipImage

        // Do any additional setup after loading the view, typically from a nib.
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
                
                // Set the scale mode to scale to fit the window
                scene?.scaleMode = .aspectFill
                
                // Present the scene
                scene?.viewController = self
                view.presentScene(scene)
           // }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer1.invalidate()
    }
    
    @IBAction func unwindToGamePlayViewController(segue: UIStoryboardSegue) {
        scene?.isPaused = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        scene?.gameTimer.invalidate()
        if segue.identifier == "scoreBoardSegue"{
            let destinationVC : ScoreBoardViewController = segue.destination as! ScoreBoardViewController
            destinationVC.theScore = scene?.score
        }
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        scene?.isPaused = true
    }
    
    func checkGameEnd(){
        if scene?.dead == true && !savedSuccess{
            deadButton.alpha = 1
            deadButton.isEnabled = true
            gameOver.alpha = 1
            let context = getContext()
            let entity =  NSEntityDescription.entity(forEntityName: "GameScore", in: context)
            let myScore = NSManagedObject(entity: entity!, insertInto: context)
            myScore.setValue(scene?.score, forKey: "score")
            myScore.setValue(playerName, forKey: "name")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            savedSuccess = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

