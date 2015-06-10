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
    
    let outputWidth  = 24
    let outputHeight = 24
    
    
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
        // Convert to CIImage
        let beginImage = CIImage(image: originalImage)
        
        // Apply MonoFilter
        var filter = CIFilter(name: "CIMaximumComponent")
        filter.setDefaults()
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        // Convert back to UIImage
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
        println("Thresholding")
        // Create threshold filter
        var thresholdFilter: GPUImageLuminanceThresholdFilter = GPUImageLuminanceThresholdFilter()
        
        // Apply filter
        let filteredImage: UIImage = thresholdFilter.imageByFilteringImage(originalImage)
        
        return filteredImage
    }
    
    /*****************************************************************
    * NEW INVERT PHOTO
    *****************************************************************/
    func invertPhoto (originalImage: UIImage) -> UIImage {
        println("Inverting")
        // Create invert filter
        var invertFilter = GPUImageColorInvertFilter()
        
        // Apply filter
        let finalImage = invertFilter.imageByFilteringImage(originalImage)
        return finalImage
    }
    
    /****************************************************************
    * OLD INVERT PHOTO
    *
    *****************************************************************/
    func oldInvertPhoto (originalImage: UIImage) -> UIImage {
        // Convert to CIImage
        let beginImage = CIImage(image: originalImage)//originalImage.CIImage //worst bug ever
        
        // Apply Invert filter
        var filter = CIFilter(name: "CIColorInvert")
        filter.setDefaults()
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        // Convert back to UIImage
        let newImage = UIImage(CIImage: filter.outputImage  ,
            scale: 1.0 ,
            orientation: UIImageOrientation.Right)
        println("Inverted image")
        return newImage!
    }
    
    /****************************************************************
    * DOWNSAMPLE
    *
    *****************************************************************/
    func downsample(originalImage: UIImage) -> UIImage {
        println("Downsampling")
        
        // Create resample filter
        var downFilter = GPUImageLanczosResamplingFilter()
        
        // Apply filter
        downFilter.forceProcessingAtSize(CGSize(width: outputWidth, height: outputHeight))
        let downSampledImage: UIImage = downFilter.imageByFilteringImage(originalImage)
        
        return downSampledImage
    }
    
    /****************************************************************
    * RESIZE PHOTO
    *
    *****************************************************************/
    func oldResize(image: UIImage, targetSize: CGSize) -> UIImage{
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
    
    /*****************************************************************
    * ALTERNATE IMAGE DUMP
    *****************************************************************/
    func altImageDump(uiimage: UIImage) -> Array<Int>{
        var pixels: Array<Int> = []
        let extractor = PixelExtractor(img: uiimage.CGImage!)
        for var x = 0; x < outputWidth; x++ {
            for var y = 0; y < outputHeight; y++ {
                pixels.append(extractor.color_at(x: x, y: y))
            }
        }
        
        print("Got \(pixels.count) pixels")
        return pixels
    }
    
    /****************************************************************
    * OLD IMAGE DUMP
    *
    *****************************************************************/
    func oldImageDump(image: UIImage) -> Array<Int>{
        println("Dumping pixels")
        let cgImage = image.CGImage
        let width = CGImageGetWidth(cgImage)
        let height = CGImageGetHeight(cgImage)
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage))
        let data = CFDataGetBytePtr(pixelData)
        var pixels: Array<Int> = []
       
        for (var i = 0; i < width; i++) {
            for (var j = 0; j < height; j++) {
                let currentPixel = ((width  * j) + i ) * 4
                pixels.append(Int(data[currentPixel]))
            }
            
        }
        println(pixels.count)
        return pixels
        }
    
    /*****************************************************************
    * GET 2D ARRAY FROM PIXEL DUMP
    *****************************************************************/
    func get2dArrayFromPixelDump(inPixels: Array<Int>) {
        var pixels: [[Int]] = Array(count: outputHeight, repeatedValue: Array(count: outputWidth, repeatedValue: 0))
        var inPixelCount = 0
        
        //columns (width)
        for (var i = 0; i < outputHeight; i++) {
            //rows (height)
            for (var j = outputWidth - 1; j >= 0; j--) {
                pixels[i][j] = inPixels[inPixelCount]
                inPixelCount++
            }
        }
    
        println("Converted pixels into 2d array!")
        for (var k = 0; k < outputHeight; k++) {
            println(pixels[k])
        }
        
    }
    
}