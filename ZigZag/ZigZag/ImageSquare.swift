//
//  ImageSquare.swift
//  zigzagpuzzle
//
//  Created by Mostafizur Rahman on 9/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ImageSquare: NSObject {
    
    fileprivate let indexRow:Int
    fileprivate let indexColumn:Int
    fileprivate let viewDimension:Int
    fileprivate var topLine:SquareType = .stUnkown
    fileprivate var leftLine:SquareType = .stUnkown
    fileprivate var rightLine:SquareType = .stUnkown
    fileprivate var bottomLine:SquareType = .stUnkown
    fileprivate var boundingRect:CGRect = .zero
    fileprivate var imageSquareView:ViewSquare?
    init(WithDimension dimension:Int, Row row:Int, Column column:Int){
        indexRow = row
        indexColumn = column
        viewDimension = dimension
        super.init()
    }
    
    func getNeighbouringIndices()->[[Int]]{
        return [[self.indexRow-1,indexColumn],
        [self.indexRow+1,indexColumn],
        [self.indexRow,indexColumn-1],
        [self.indexRow,indexColumn+1]]
    }
    
    func setLine(Type lineType:SquareType){//only top and left
        if lineType.rawValue / 10 == 2 {//found right edge line
            //setting left edge
            self.leftLine = lineType == .rightOut ? .leftIn : .leftOut
        } else if lineType.rawValue / 10 == 4 {//found bottom ednge line
            //setting top edge
            self.topLine = lineType == .bottomOut ? .topIn : .topOut
        } else {
            assertionFailure("This will never be exicuted")
        }
    }
    
    func setRightRandomLine(){
        let number = Int.random(in: 0 ... 1)
        self.rightLine = SquareType.init(rawValue: 20 + number) ?? .stUnkown
    }
    
    func setBottomRandomLine(){
        let number = Int.random(in: 0 ... 1)
        self.bottomLine = SquareType.init(rawValue: 40 + number) ?? .stUnkown
    }
    
    func setRightLine(){
        self.rightLine = .rightEdge
    }
    
    func setBottomLine(){
        self.bottomLine = .bottomEdge
    }
    
    func setTopLine(){
        self.topLine = .topEdge
    }
    
    func setLeftLine(){
        self.leftLine = .leftEdge
    }
    
    func getLeftLine()->SquareType{
        return self.leftLine
    }
    
    func getRightLine()->SquareType{
        return self.rightLine
    }
    
    func getTopLine()->SquareType{
        return self.topLine
    }
    
    func getBottomLine()->SquareType{
        return self.bottomLine
    }
    
    func createSurface(){
        
        let length = Int(CGFloat(self.viewDimension) * 0.1)
        let originX = self.indexColumn * self.viewDimension - (self.leftLine == .leftOut ? length : 0)
        let originY = self.indexRow * self.viewDimension - (self.topLine == .topOut ? length : 0)
        let _width = self.viewDimension + (self.rightLine == .rightOut ? length : 0) + (self.leftLine == .leftOut ? length : 0)
        let _height = self.viewDimension + (self.bottomLine == .bottomOut ? length : 0) + (self.topLine == .topOut ? length : 0)
        self.boundingRect = CGRect(x: originX, y: originY, width: _width, height: _height)
        self.imageSquareView = ViewSquare(Types: [self.topLine, self.leftLine, self.rightLine, self.bottomLine],
                                     width: self.viewDimension, frame: self.boundingRect)
    }
    
    
    func setSlice(Image image:UIImage) {
        self.imageSquareView?.sliceImage = image
    }
    
    func getSurceView()->ViewSquare?{
        return self.imageSquareView
    }
    
    func toString(){
        print("top \(self.topLine.rawValue) left \(self.leftLine.rawValue) bottom \(self.bottomLine.rawValue) right \(self.rightLine.rawValue)")
        print("row \(self.indexRow) column \(self.indexColumn)")
    }
}
