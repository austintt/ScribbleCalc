//
//  PhotoManipulator.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 5/26/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import UIKit
import CoreImage
import GPUImage

class PhotoManipulator: NSObject {
    
    var filter: CIFilter
    
    /****************************************************************
    * CONSTRUCTOR
    *
    *****************************************************************/
    override init() {
        filter = CIFilter(name: "CIPhotoEffectNoir")
    }
    
    /****************************************************************
    * PROCESS PHOTO
    *
    *****************************************************************/
    func processPhoto(image: UIImage) -> UIImage {
//        newImage = convertToGrayscale(newImage)
//        let newerImage = invertPhoto(image)
        let newImage = thresholdPhoto(image)
        
//        let newestImage = cropToSquare(image)
        
        return thresholdPhoto(image)
    }
    
    /****************************************************************
    * CROP TO SQUARE
    *
    *****************************************************************/
    func cropToSquare(originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height for our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
    }
    
    /****************************************************************
    * CONVERT TO GRAYSCALE
    *
    *****************************************************************/
    func convertToGrayscale(originalImage: UIImage) -> UIImage {
        //convert to CIImage
        let beginImage = CIImage(image: originalImage)
        
        //Apply MonoFilter
        filter = CIFilter(name: "CIMaximumComponent")
        filter.setDefaults()
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        //Convert back to UIImage
        let newImage = UIImage(CIImage: filter.outputImage) /*,
            scale: 1.0 ,
            orientation: UIImageOrientation.Right)*/
        println("Created grayscale image")
        return newImage!
    }
    
    /****************************************************************
    * THRESHOLD PHOTO
    *
    *****************************************************************/
    func thresholdPhoto (originalImage: UIImage) -> UIImage {
        let inputImage: UIImage = originalImage
        var thresholdFilter: GPUImageLuminanceThresholdFilter = GPUImageLuminanceThresholdFilter()
        var invertFilter = GPUImageColorInvertFilter()
        let filteredImage: UIImage = thresholdFilter.imageByFilteringImage(inputImage)
        let finalImage = invertFilter.imageByFilteringImage(filteredImage)
    
        return finalImage
    }
    
    /****************************************************************
    * INVERT PHOTO
    *
    *****************************************************************/
    func invertPhoto (originalImage: UIImage) -> UIImage {
        //convert to CIImage
        let beginImage = CIImage(image: originalImage)//originalImage.CIImage //worst bug ever
        
        //Apply Invert filter
        filter = CIFilter(name: "CIColorInvert")
        filter.setDefaults()
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        //Convert back to UIImage
        let newImage = UIImage(CIImage: filter.outputImage  ,
            scale: 1.0 ,
            orientation: UIImageOrientation.Right)
        println("Inverted image")
        return newImage!
    }
    
    /****************************************************************
    * RESIZE PHOTO
    *
    *****************************************************************/
    func resize(image: UIImage, targetSize: CGSize) -> UIImage{
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}