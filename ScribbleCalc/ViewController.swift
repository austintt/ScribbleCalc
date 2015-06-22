//
//  ViewController.swift
//  ScribbleCalc
//
//  Created by Austin Tooley on 4/29/15.
//  Copyright (c) 2015 Austin Tooley. All rights reserved.
//

import UIKit
//import MobileCoreServices

//global consts
let trainingSource = "trainingsample"
let testingSource = "validationsample"
var hasLoadedTrainingData = false

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var charactersFoundLabel: UILabel!
    @IBOutlet weak var trainingDataLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var testDataLabel: UILabel!
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    var trainingRowData: [[Int]] = []
    var trainingRowLabels = [Int]()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load up training pixel data
        trainingDataLabel.text = "Attempting to load training data..."
        if !hasLoadedTrainingData {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                hasLoadedTrainingData = true
                let csvContents = getContentsOfCSV(trainingSource)
                self.trainingRowData = csvContents.rows
                self.trainingRowLabels = csvContents.trainingRowLabels
                dispatch_async(dispatch_get_main_queue()) {
                    self.trainingDataLabel.text = "Loaded pixel data from \(self.trainingRowData.count) training images"
                }
            }
        }
    }
    
    
    
    /*************************************************************
    * CAMERA SETUP
    *************************************************************/
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        // Process Image
        self.testDataLabel.text = "Processing image..."
        let manipulator = PhotoManipulator()
        imageView.image = manipulator.cropToSquare((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        imageView.image = manipulator.downsample(imageView.image!, width: outputWidth, height: outputHeight)
        imageView.image = manipulator.thresholdPhoto(imageView.image!)
        imageView.image = manipulator.invertPhoto(imageView.image!)
        
        // Convert
        self.testDataLabel.text = "Image processed! Getting pixel data..."
        var testPixelData = manipulator.altImageDump(imageView.image!)
        self.testDataLabel.text = "Got \(testPixelData.count) pixels from test image!"
        
        // Get multi array
        var pixels2DArray: [[Int]] = manipulator.get2dArrayFromPixelDump(testPixelData)
        
        //Aggressively clean up
        testPixelData = []
        
        // Find characters
        var characters = manipulator.segmentCharacters(pixels2DArray)
        charactersFoundLabel.text = "Found \(characters.count) characters"
        
        //flatten 2d array of found characters
        var flatTestRows = manipulator.flatten2dArrayWhereCharactersFound(characters, pixels: pixels2DArray)
        
        //Aggressively clean up
        pixels2DArray = [[]]
        
        // Convert back to uiimage
        var reConvertedImages = [UIImage]()
        var i = 0
        for row in flatTestRows {
            var newPixelRow = [PixelData]()
            for (var j = 0; j < row.count; j++) {
                let newPixel = PixelData(value: row[j])
                newPixelRow.append(newPixel)
            }
            let width = characters[i].endCol - characters[i].startCol + 1
            let height = characters[i].endRow - characters[i].startRow + 1
            println("Converting to width: \(width) height: \(height)")
            let imageOfRow = manipulator.imageFromARGB32Bitmap(newPixelRow, width: width, height: height)
            
            // Downsample to 28x28
            reConvertedImages.append(manipulator.downsample(imageOfRow, width: 28, height: 28))
            i++
        }
        
        println("RECONVERTED: \(reConvertedImages.count) images")
        imageView.image = reConvertedImages[0]
        
        //Aggressively clean up
        flatTestRows = [[]]
        
        // Dump
        for convImage in reConvertedImages {
            println("RECEIVED AT: \(convImage.size.width) X \(convImage.size.height)")
            println("Size: \(convImage.size.width * convImage.size.height) ")
            flatTestRows.append(manipulator.altImageDump(convImage))
        }
        
        // DEBUG
        if (flatTestRows[0].count == 0){
            flatTestRows.removeAtIndex(0)
        }
        
        println("Attempting knn on \(flatTestRows.count)")
        
        // Knn
        var rec = Recognizer()
        println("Training Row data: \(trainingRowData.count)")
        var recognizedLables = rec.knn(5, trainingRows: trainingRowData, trainingRowLables: trainingRowLabels, testRows: flatTestRows)
        
    }
    
    /*************************************************************
    * MISC FUNCTIONS
    *************************************************************/
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

