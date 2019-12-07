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
    fileprivate let sourceImageName:String
    fileprivate let emptySquare = ImageSquare(WithDimension: -1, Row: -1, Column: -1)
    var squareArray:[ImageSquare] = []
    var imageHandler:ImageHandler!
    
    init(WithRow row:Int, Column column:Int,
         ScreenHeight height:Int, Image source:String, inView _view:UIView) {
        rowCount = row
        columnCount = column
        sourceImageName = source
        screenHeight = height
        super.init()
        self.configureSaqure(ToView: _view)
    }
    
    fileprivate func configureSaqure(ToView _view:UIView){
        let dimension = self.screenHeight / self.rowCount
        let screenWidth = dimension * self.columnCount
        self.imageHandler = ImageHandler(WithDimension: dimension, imagePath: sourceImageName)
        self.imageHandler.setupContext(ForRow: self.rowCount, Column: self.columnCount, Scale: UIScreen.main.scale)
       
        for row in 0...self.rowCount-1{
            for column in 0...self.columnCount-1{
                let square = ImageSquare(WithDimension: dimension,
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
                if let _ = square.createSurface(ToView:_view){
                    
                     let (image, path, _size) = imageHandler.getImage(ForRow: row,
                                                                      Column: column,
                                                                      borderTypes: square.getBorders())
                    if let _image = image {
                        square.setSlice(Image: _image)
                    }
                    if let _image = imageHandler.getMaskImage(path, _size) {
                        square.setBorder(Image: _image)
                    }
                }
                square.setRandomPosition(initialX: screenWidth,
                                         parentWidth: Int(_view.bounds.width),
                                         parentHeight: Int(_view.bounds.height))
            }
        }
    }
   
    
    func getNeighbouringSquare(Row row:Int, Column column:Int)->ImageSquare?{
        if row < 0 || column < 0 ||
            row >= self.rowCount || column >= self.columnCount {
            return nil
        }
        let index = row * self.columnCount + column
        if self.squareArray.count > index {
            return self.squareArray[index]
        }
        return self.emptySquare
    }
    
    func getView(FromPoint point:CGPoint)->(ViewSquare?, CGRect?){
        for _square in self.squareArray {
            if let _view = _square.getSurceView(forPoint: point) {
                return (_view, _square.getSurfaceView()?.frame)
            }
        }
        return (nil, nil)
    }
    
    func playAgain(parentWidth _width: Int,
                   parentHeight _height: Int){
        let dimension = self.screenHeight / self.rowCount
        let screenWidth = dimension * self.columnCount
        for _square in self.squareArray {
            _square.setRandomPosition(initialX: screenWidth, parentWidth: _width, parentHeight: _height)
        }
    }
    
    func isGameOver()->Bool {
        for _square in self.squareArray {
            if let _surface = _square.getSurfaceView(), let _sourceView = _square.getSurceView() {
                if !_surface.frame.contains(_sourceView.center) {
                    return false
                }
            }
        }
        return true
    }
    
}



