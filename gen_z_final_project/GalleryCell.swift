//
//  GalleryCell.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 12/3/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import Foundation

import UIKit

class GalleryCell: UICollectionViewCell{
    
    @IBOutlet weak var cellImage: UIImageView!
    
    var picName: String = "unknown"
    
    func setGalleryItem(_ item:GalleryItem) {
        cellImage.image = UIImage(named: item.itemImage)
        picName = item.itemImage
    }
    
    func getPicName() -> String {
        return picName
    }
}
