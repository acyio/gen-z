//
//  CustomButtonView.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 11/10/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import UIKit
@IBDesignable

class CustomButtonView: UIButton {

    @IBInspectable var edgeColor: UIColor = UIColor.blue
    
    override func draw(_ rect: CGRect){
        edgeColor.setStroke()
        
        let path = UIBezierPath()
        path.lineWidth = 5.0
        path.move(to: CGPoint(x:0,y:0))
        path.addLine(to: CGPoint(x:(7/8)*bounds.width ,y:0))
        path.addLine(to: CGPoint(x:bounds.width,y:(1/8)*bounds.height))
        path.addLine(to: CGPoint(x:bounds.width,y:bounds.height))
        path.addLine(to: CGPoint(x:(1/8)*bounds.width,y:bounds.height))
        path.addLine(to: CGPoint(x:0,y:(7/8)*bounds.height))
        path.addLine(to: CGPoint(x:0,y:0))
        path.stroke()
    }

}
