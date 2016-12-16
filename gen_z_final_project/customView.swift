//
//  MainCharacter.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 11/18/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import UIKit
import CoreData
import Foundation
@IBDesignable

class customView: UIView {

    @IBInspectable var fillColor: UIColor = UIColor.green
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
    }

}
