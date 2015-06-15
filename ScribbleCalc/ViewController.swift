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
    var trainingPixelData: [[Int]] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load up training pixel data
        trainingDataLabel.text = "Attempting to load training data..."
        if !hasLoadedTrainingData {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                hasLoadedTrainingData = true
                self.trainingPixelData = getContentsOfCSV(trainingSource)
                dispatch_async(dispatch_get_main_queue()) {
                    self.trainingDataLabel.text = "Loaded pixel data from \(self.trainingPixelData.count - 1) training images"
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
        imageView.image = manipulator.downsample(imageView.image!)
        imageView.image = manipulator.thresholdPhoto(imageView.image!)
        imageView.image = manipulator.invertPhoto(imageView.image!)
        
        // Convert
        self.testDataLabel.text = "Image processed! Getting pixel data..."
        let testPixelData = manipulator.altImageDump(imageView.image!)
        self.testDataLabel.text = "Got \(testPixelData.count) pixels from test image!"
        
        // Get multi array
        let pixels2DArray: [[Int]] = manipulator.get2dArrayFromPixelDump(testPixelData)
        
        // Find characters
        var characters = manipulator.segmentCharacters(pixels2DArray)
        charactersFoundLabel.text = "Found \(characters.count) characters"
        
        //flatten 2d array of found characters
        
        // Knn
        
    }
    
    /*************************************************************
    * MISC FUNCTIONS
    *************************************************************/
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

