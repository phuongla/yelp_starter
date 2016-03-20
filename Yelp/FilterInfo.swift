//
//  FilterInfo.swift
//  Yelp
//
//  Created by phuong le on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterInfo: NSObject {
    
    var isOffer: Bool = false
    //0: auto
    var distance: Float = 0
    var sortBy: YelpSortMode = YelpSortMode.BestMatched
    var category:[String] = []
    
    init(isOffer:Bool, distance:Float, sortBy:YelpSortMode, category:[String] ){
        
        self.isOffer = isOffer
        self.distance = distance
        self.sortBy = sortBy
        self.category = category
    }

}
