//
//  ScoreBoardViewController.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 11/10/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Social

class ScoreBoardViewController: UIViewController {
    
    var theScore: Int!

    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    @IBOutlet weak var score5: UILabel!
    @IBOutlet weak var score6: UILabel!
    @IBOutlet weak var score7: UILabel!
    @IBOutlet weak var score8: UILabel!
    @IBOutlet weak var score9: UILabel!
    @IBOutlet weak var score10: UILabel!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var name5: UILabel!
    @IBOutlet weak var name6: UILabel!
    @IBOutlet weak var name7: UILabel!
    @IBOutlet weak var name8: UILabel!
    @IBOutlet weak var name9: UILabel!
    @IBOutlet weak var name10: UILabel!
    
    //struct highScores {
        //var name: String
        //var score: Int
    //}
    
    //var hsArray: [highScores]
    
    var dict: [String : Int] = [
        "john": 0,
        "jen": 0,
        "tay": 0,
        "mike": 0,
        "abe": 0,
        "dave": 0,
        "jay": 0,
        "barry": 0,
        "wally": 0,
        "bart": 0,
        ]
    
    @IBAction func twitterButton(_ sender: Any) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            
            let tweetController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            if (theScore == nil){
                theScore = 0
            }
    
            tweetController?.setInitialText("Wow! Would you look at that? I scored \((theScore)!) points on Gen-Z!")
            
            self.present(tweetController!, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Accounts", message: "Please login to your Twitter", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: {
                (UIAlertAction) in
                
                let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
                
                if let url = settingsURL{
                    UIApplication.shared.openURL(url as URL)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToScoreBoardMenu(segue: UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScores()
        let d = (dict.values).sorted(by: >)
        let myArr = Array(dict.keys)
        
        // Taken from Stack Overflow
        var sortedKeys = myArr.sorted() {
            let obj1 = dict[$0] // get ob associated w/ key 1
            let obj2 = dict[$1] // get ob associated w/ key 2
            return obj1! > obj2!
        }

        name1.text = String(sortedKeys[0])
        name2.text = String(sortedKeys[1])
        name3.text = String(sortedKeys[2])
        name4.text = String(sortedKeys[3])
        name5.text = String(sortedKeys[4])
        name6.text = String(sortedKeys[5])
        name7.text = String(sortedKeys[6])
        name8.text = String(sortedKeys[7])
        name9.text = String(sortedKeys[8])
        name10.text = String(sortedKeys[9])
        score1.text = "\(d[0])"
        score2.text = "\(d[1])"
        score3.text = "\(d[2])"
        score4.text = "\(d[3])"
        score5.text = "\(d[4])"
        score6.text = "\(d[5])"
        score7.text = "\(d[6])"
        score8.text = "\(d[7])"
        score9.text = "\(d[8])"
        score10.text = "\(d[9])"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getScores () {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<GameScore> = GameScore.fetchRequest()
        var count: Int = 0
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for myScores in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                dict[("\(myScores.value(forKey: "name")!)")] = (myScores.value(forKey: "score")! as! Int)
                if count < 9 {
                    count += 1
                }
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
