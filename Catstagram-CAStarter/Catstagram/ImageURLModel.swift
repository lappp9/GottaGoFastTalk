//
//  ImageURLModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/14/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class ImageURLModel {
    
    class func imageParameter(forClosestImageSize size:CGSize) -> String {
        let squareImageRequested = size.width == size.height
        var imageParameterID:Int = 0
        if squareImageRequested {
            imageParameterID = imageParameter(forSquareCroppedSize: size)
        }
        return "&image_size=\(imageParameterID)"
    }
    
    class func imageParameter(forSquareCroppedSize size:CGSize) -> Int {
        var imageParameterID:Int = 0
        
        if size.height <= 70 {
            imageParameterID = 1
        } else if size.height <= 100 {
            imageParameterID = 100
        } else if size.height <= 140 {
            imageParameterID = 2
        } else if size.height <= 200 {
            imageParameterID = 200
        } else if size.height <= 280 {
            imageParameterID = 3
        } else if size.height <= 400 {
            imageParameterID = 400
        } else {
            imageParameterID = 600
        }
        
        return imageParameterID
    }
}
