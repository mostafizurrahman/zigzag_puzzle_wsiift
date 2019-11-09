//
//  SquareTypes.swift
//  zigzagpuzzle
//
//  Created by Mostafizur Rahman on 9/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

enum SquareType: Int {
    case stUnkown = 0, leftEdge = 1, rightEdge = 2, topEdge = 3, bottomEdge = 4,
    leftOut = 10, leftIn = 11, rightOut = 20, rightIn = 21,
    topOut = 30, topIn = 31, bottomOut = 40 , bottomIn = 41
}

