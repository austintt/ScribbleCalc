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
let trainingSource = "trainingsampleWithPlus"
let testingSource = "test"
var hasLoadedTrainingData = false

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var charGuess: UILabel!
    @IBOutlet weak var charactersFoundLabel: UILabel!
    @IBOutlet weak var trainingDataLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var testDataLabel: UILabel!
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    var trainingRowData: [[Int]] = []
    var trainingRowLabels = [String]()
    var dummyData = DummyDataTest()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load up training pixel data
        trainingDataLabel.text = "Attempting to load training data..."
        if !hasLoadedTrainingData {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                hasLoadedTrainingData = true
                let csvContents = getContentsOfCSV(trainingSource, true)
                self.trainingRowData = csvContents.rows
                self.trainingRowLabels = csvContents.trainingRowLabels
                dispatch_async(dispatch_get_main_queue()) {
                    self.trainingDataLabel.text = "Loaded pixel data from \(self.trainingRowData.count) training images"
                    
                    //DISPLAY TRAINING DATA
//                    var newPixelRow = [PixelData]()
//                    for (var j = 0; j < self.trainingRowData[36].count; j++) {
//                        let newPixel = PixelData(value: self.trainingRowData[36][j])
//                        newPixelRow.append(newPixel)
//                    }
//                    let manipulator = PhotoManipulator()
//                    let testImg = manipulator.imageFromARGB32Bitmap(newPixelRow, width: 28, height: 28)
//                    self.imageView.image = testImg
                    println("TRAINING DATA:")
                    var manip = PhotoManipulator()
                    println(manip.get2dArrayFromPixelDump(self.trainingRowData[3], height: 28, width: 28))
                    
                }
            }
        }
    }
    
    @IBAction func loadTestData(sender: AnyObject) {
        var testRow = dummyData.getRandom()
        println("Testing dummy data")
        println(testRow)
        
        var newPixelRow = [PixelData]()
        for (var j = 0; j < testRow.count; j++) {
            let newPixel = PixelData(value: testRow[j])
            newPixelRow.append(newPixel)
        }
        let manipulator = PhotoManipulator()
        let testImg = manipulator.imageFromARGB32Bitmap(newPixelRow, width: 28, height: 28)
        self.imageView.image = testImg
        
        var newTestRows = [[Int]]()
        newTestRows.append(testRow)
        
        let knn = Recognizer()
        var guesses = knn.knn(5, trainingRows: trainingRowData, trainingRowLables: trainingRowLabels, testRows: newTestRows)
        
        //DEBUG
        self.charGuess.text = "Guess: \(guesses[0])"
        self.charGuess.textColor = UIColor.redColor()
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
        var pixels2DArray: [[Int]] = manipulator.get2dArrayFromPixelDump(testPixelData, height: outputHeight, width: outputHeight)
        
        //Aggressively clean up
        testPixelData = []
        
        // Find characters
        var characters = manipulator.segmentCharacters(pixels2DArray)
        
        // Fail gracefully if no characters are found
        if (characters.count < 1 || characters.count > 10) {
            charactersFoundLabel.text = "ERROR: NO CHARACTERS FOUND, TRY AGAIN"
            return
        }
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
            
            // Downsample to 14x20
            reConvertedImages.append(manipulator.downsample(imageOfRow, width: 14, height: 20))
            i++
            
        }
        
        println("RECONVERTED: \(reConvertedImages.count) images")
        
        
        //Aggressively clean up
        flatTestRows = [[]]
        
        // Dump
        for (var i = 0; i < reConvertedImages.count; i++) {
            println("RECEIVED AT: \(reConvertedImages[i].size.width) X \(reConvertedImages[i].size.height)")
            println("Size: \(reConvertedImages[i].size.width * reConvertedImages[i].size.height) ")
            
            // Padding
            reConvertedImages[i] = manipulator.insertPaddingIntoCharacter(reConvertedImages[i], height: 28, width: 28)
            
            flatTestRows.append(manipulator.altImageDump(reConvertedImages[i]))
        }
        
        var dataCheck = manipulator.get2dArrayFromPixelDump(flatTestRows[1], height: 28, width: 28)
        println("Printing DatqaCheck")
        println(dataCheck)
        
        //imageView.image = reConvertedImages[0]
//        for row in flatTestRows {
//            // Insert padding
//            var paddedFlatData = manipulator.insertPaddingIntoCharacter(row, height: 18, width: 25)
//            var newPixelRow = [PixelData]()
//            for (var j = 0; j < paddedFlatData.count; j++) {
//                let newPixel = PixelData(value: paddedFlatData[j])
//                newPixelRow.append(newPixel)
//                let imageOfRow = manipulator.imageFromARGB32Bitmap(newPixelRow, width: 28, height: 28)
//                imageView.image = imageOfRow
//            }
    //}

        // DEBUG
        if (flatTestRows[0].count == 0){
            flatTestRows.removeAtIndex(0)
        }
        
        
        
        println("Attempting knn on \(flatTestRows.count)")
        
//        // Knn
        var rec = Recognizer()
        println("Training Row data: \(trainingRowData.count)")
        var recognizedLables = rec.knn(4, trainingRows: trainingRowData, trainingRowLables: trainingRowLabels, testRows: flatTestRows)
        //DEBUG
        var labels = ""
        for label in recognizedLables {
            labels += "\(label) "
        }
        self.charGuess.text = "Guess: \(labels)"
        self.charGuess.textColor = UIColor.redColor()
        
    }
    
    /*************************************************************
    * MISC FUNCTIONS
    *************************************************************/
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

