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

let outputWidth  = 500
let outputHeight = 500

class PhotoManipulator: NSObject {
    
    
    
    
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
    func downsample(originalImage: UIImage, width: Int, height: Int) -> UIImage {
        println("Downsampling")
        
        // Create resample filter
        var downFilter = GPUImageLanczosResamplingFilter()
        
        // Apply filter
        downFilter.forceProcessingAtSize(CGSize(width: width, height: height))
        let downSampledImage: UIImage = downFilter.imageByFilteringImage(originalImage)
        
        println("DOWNSAMPLED AT \(downSampledImage.size.width) x \(downSampledImage.size.height)")
        
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
        for var x = 0; x < Int(uiimage.size.width); x++ {
            for var y = 0; y <  Int(uiimage.size.height); y++ {
                pixels.append(extractor.color_at(x: x, y: y))
            }
        }
        
        println("Got \(pixels.count) pixels")
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
    func get2dArrayFromPixelDump(inPixels: Array<Int>, height: Int, width: Int) -> [[Int]]{
        var pixels: [[Int]] = Array(count: height, repeatedValue: Array(count: width, repeatedValue: 0))
        var inPixelCount = 0
        
        //columns (width)
        for (var i = 0; i < height; i++) {
            //rows (height)
            for (var j = 0; j < width; j++) {
                pixels[i][j] = inPixels[inPixelCount]
                inPixelCount++
            }
        }
    
        println("Converted pixels into 2d array!")
//        for (var k = 0; k < outputHeight; k++) {
//            println(pixels[k])
//        }
        return pixels
    }
    
    
    /*****************************************************************
    * INSERT PADDING INTO CHARACTER
    *****************************************************************/
    func insertPaddingIntoCharacter(imageTop: UIImage, height: Int, width: Int) -> UIImage{
        
        println("Attempting to add padding...")
        var bottomImage:UIImage = UIImage(named:"white.png")!
        
        var newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height)
        UIGraphicsBeginImageContext( newSize )
        
        bottomImage.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
        
        // decrease top image to 36x36
        imageTop.drawInRect(CGRectMake(bottomImage.size.width / 4,bottomImage.size.height / 7,14,20), blendMode:kCGBlendModeNormal, alpha:1.0)
        
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        newImage = newImage.imageRotatedByDegrees(-90.0, flip: false)

        return newImage
    }
    
    /*****************************************************************
    * SEGMENT CHARACTERS
    * 
    * Margins are set to 1px on top, bottom, left, and right
    *****************************************************************/
    func segmentCharacters(pixels: [[Int]]) -> Array<ImgCharacter>{
        println("Segmenting")
        var characters = [ImgCharacter]()
        var startedChar = false
        var prevlineAverage = 0
        var lineAverage = 0
        var columnCount = 0
        var rowCount = 0
        var newCharacter = ImgCharacter()
        var currentCharacter = 0
        let margin = 2
        
        // TODO: Decide how big of a magrgin on each side of character. Currently none on left or top
        // But 1 on right and bottom.
        // TODO: Height finder needs to work within params found from width finder, otherwise, finds highest and lowest
        
        println("Col average:")
        // Find character by vertical average
        for (var row = 0; row < outputWidth; row++) {
            // Compute average
            for (var col = 0; col < outputHeight; col++) {
                lineAverage += pixels[col][row]
            }
            
            lineAverage = lineAverage / outputHeight
            
            // If character is starting
            if (!startedChar && lineAverage > 0 && prevlineAverage > 0) {
                newCharacter = ImgCharacter()
                startedChar = true
                assert(columnCount - margin >= 0, "Out of bounds on columnCount")
                newCharacter.startCol = columnCount - margin
            }
                
                // If character is ending
            else if (startedChar && lineAverage == 0 && prevlineAverage == 0) {
                startedChar = false
                newCharacter.endCol = columnCount
                characters.append(newCharacter)
            }
            
            // Prep for next
            prevlineAverage = lineAverage
            lineAverage = 0
            columnCount++
        }
        
        // Reset
        prevlineAverage = 0
        lineAverage = 0
        startedChar = false
        
        
        // Find top and bottom of each character
        // DEBUG - make this more efficient by stopping once found, instead of itterting
        // through each remaining char
        println("Row average:")
        for (var row = 0; row < outputHeight; row++) {
            for (var col = 0; col < outputWidth; col++) {
                lineAverage += pixels[row][col]
            }
            
            lineAverage = lineAverage / outputWidth
            
            // If character is starting
            if (!startedChar && lineAverage > 0 && prevlineAverage > 0) {
                startedChar = true
                
                //double check that we are still in bounds
                if (currentCharacter < characters.count) {
                    assert(rowCount - margin >= 0, "Out of bounds on rowCount")
                    characters[currentCharacter].startRow = rowCount - margin // DEBUG DANGEROUS
                }
                else {println("Error: out of bounds in segmenter")}
            }
                
                // If character is ending
            else if (startedChar && lineAverage == 0 && prevlineAverage == 0) {
                startedChar = false
                
                //double check that we are still in bounds
                if (currentCharacter < characters.count) {
                    characters[currentCharacter].endRow = rowCount
                    currentCharacter++
                }
                else {println("Error: out of bounds in segmenter")}
            }
            
            // Prep for next
            prevlineAverage = lineAverage
            lineAverage = 0
            rowCount++
        }
        
        
        //Debug fix this so we don't need it
        if (characters.count > 0) {
            if (characters[0].startRow > 0) {
                for (var i = 1; i < characters.count; i++) {
                    characters[i].startRow = characters[0].startRow
                    characters[i].endRow = characters[0].endRow
                    println("Here")
                }
            }
        }
        
        // Verify that the distance between start and end are big enough for char
        for (var i = 0; i < characters.count; i++) {
            //get rid of things that are too small
            if ((characters[i].endCol - characters[i].startCol) < 8) {
                println("FOUND SOMETHING TOO SMALL")
                characters.removeAtIndex(i)
            }
        }
        
        //DEBUG
        for char in characters {
            print("SC: \(char.startCol) EC: \(char.endCol)\n")
            print("SR: \(char.startRow) ER: \(char.endRow)\n\n")
        }
        
        // DEBUG
        //        println("Testing locations...")
        //        for char in characters {
        //            for
        //        }
        
        
        return characters
    }
    
    /*****************************************************************
    * FLATTEN 2D ARRAY WHERE CHARACTERS FOUND
    *****************************************************************/
    func flatten2dArrayWhereCharactersFound(characterLocations: [ImgCharacter], pixels: [[Int]]) -> [[Int]]{
        println("Flattening 2d array...")
        var locs = characterLocations
        var rows: [[Int]] = []
        
        // Go through each character location
        for loc in locs {
            // Create a new array to hold row data
            var newRow = [Int]()
            
            // For each row
            for (var row = loc.startRow; row <= loc.endRow; row++) {
                //Go through each column and get the value
                for (var col = loc.startCol; col <= loc.endCol; col++) {
                    newRow.append(pixels[row][col])
                }
            }
            
            rows.append(newRow)
        }
        for row in rows {
            println(row.count)
        }
        return rows
    }
    
    /*****************************************************************
    * IMAGE FROM RGB 32 BITMAP
    *****************************************************************/
    func imageFromARGB32Bitmap(pixels:[PixelData], width: Int, height: Int)-> UIImage {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let bitsPerComponent:Int = 8
        let bitsPerPixel:Int = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        let cgim = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * Int(sizeof(PixelData)),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            kCGRenderingIntentDefault
        )
        return UIImage(CGImage: cgim)!
    }
    
    
    
    func getUIImageForRGBAData(width: Int, height: Int, data: NSData) -> UIImage? {
        let pixelData = data.bytes
        let bytesPerPixel = 4
        let scanWidth = bytesPerPixel * width
        
        let provider = CGDataProviderCreateWithData(nil, pixelData, height * scanWidth, nil)
        
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo:CGBitmapInfo = .ByteOrderDefault;
        bitmapInfo |= CGBitmapInfo(CGImageAlphaInfo.Last.rawValue)
        let renderingIntent = kCGRenderingIntentDefault;
        
        let imageRef = CGImageCreate(width, height, 8, bytesPerPixel * 8, scanWidth, colorSpaceRef,
            bitmapInfo, provider, nil, false, renderingIntent);
        
        return UIImage(CGImage: imageRef)
    }
    
}