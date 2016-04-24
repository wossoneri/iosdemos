//
//  Player.swift
//  IBLearning
//
//  Created by wossoneri on 16/4/24.
//  Copyright © 2016年 wossoneri. All rights reserved.
//


import UIKit

struct Player {
    var name: String?
    var game: String?
    var rating: Int
    
    init(name: String?, game: String?, rating: Int) {
        self.name = name
        self.game = game
        self.rating = rating
    }
    
}