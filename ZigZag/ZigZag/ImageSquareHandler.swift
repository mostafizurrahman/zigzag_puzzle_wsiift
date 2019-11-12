//
//  ImageSquareHandler.swift
//  zigzagpuzzle
//
//  Created by Mostafizur Rahman on 9/11/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ImageSquareHandler: NSObject {
    
    fileprivate let rowCount:Int
    fileprivate let columnCount:Int
    fileprivate let screenHeight:Int
    fileprivate let drawImage:UIImage
    fileprivate let emptySquare = ImageSquare(WithDimension: -1, Row: -1, Column: -1)
    var squareArray:[ImageSquare] = []
    
    init(WithRow row:Int, Column column:Int,
         ScreenHeight height:Int, Image source:UIImage) {
        rowCount = row
        columnCount = column
        drawImage = source
        screenHeight = height
        super.init()
        self.configureSaqure()
    }
    
    fileprivate func configureSaqure(){
        for row in 0...self.rowCount-1{
            for column in 0...self.columnCount-1{
                let square = ImageSquare(WithDimension: self.screenHeight / self.rowCount,
                                         Row: row,
                                         Column: column)
                self.squareArray.append(square)
                //left square
                if let _leftSquare = self.getNeighbouringSquare(Row: row, Column: column-1) {
                    if !_leftSquare.isEqual(self.emptySquare){
                        let rightLine = _leftSquare.getRightLine()
                        square.setLine(Type: rightLine)
                    } else {
                        assertionFailure("Should not be executed")
                    }
                } else {
                    square.setLeftLine()
                }
                
                //right square
                if let rightSquare = self.getNeighbouringSquare(Row: row, Column: column+1){
                    if rightSquare.isEqual(self.emptySquare){
                        square.setRightRandomLine()
                    } else {
                        assertionFailure("Should not be executed")
                    }
                } else {
                    square.setRightLine()
                }
                
                //bottom square
                if let bottomSquare = self.getNeighbouringSquare(Row: row+1, Column: column){
                    if bottomSquare.isEqual(self.emptySquare){
                        square.setBottomRandomLine()
                    } else {
                        assertionFailure("Should not be executed")
                    }
                } else {
                    square.setBottomLine()
                }
                
                //top square
                if let topSquare = self.getNeighbouringSquare(Row: row-1, Column: column){
                    if !topSquare.isEqual(self.emptySquare){
                        let topLine = topSquare.getBottomLine()
                        square.setLine(Type: topLine)
                    }
                } else {
                    square.setTopLine()
                }
                square.createSurface()
                square.setSlice(Image: <#T##UIImage#>)
                square.toString()
            }
        }
    }
   
    
    func getNeighbouringSquare(Row row:Int, Column column:Int)->ImageSquare?{
        if row < 0 || column < 0 ||
            row > self.rowCount || column > self.columnCount {
            return nil
        }
        let index = row * self.columnCount + column
        if self.squareArray.count > index {
            return self.squareArray[index]
        }
        return self.emptySquare
    }

}
