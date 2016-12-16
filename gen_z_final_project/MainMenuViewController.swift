//
//  MainMenuViewController.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 11/8/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MainMenuViewController: UIViewController {
    
    var shipImage: String!
    var playerName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicHelper.sharedHelper.playBackgroundMusic()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindToMainMenu(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scoreBoardSegueFromMenu"{
            let destinationVC : ScoreBoardViewController = segue.destination as! ScoreBoardViewController
            destinationVC.theScore = 0
        }
    }
    
}
