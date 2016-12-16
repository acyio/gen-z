//
//  GalleryItem.swift
//  gen_z_final_project
//
//  Created by Jake Lehmann on 12/3/16.
//  Copyright © 2016 Jake Lehmann, Abrahamn Musalem, And Yang, Dingyu Wang. All rights reserved.
//

import Foundation

class GalleryItem{
    
    var itemImage: String
    
    init(dataDictionary:Dictionary<String,String>) {
        itemImage = dataDictionary["itemImage"]!
    }
    
}
