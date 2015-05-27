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

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    var trainingPixelData: [[String]] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        //Process Image
        let manipulator = PhotoManipulator()
        
        //crop
        imageView.image = manipulator.processPhoto((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        
//        //grayscale
//        imageView.image = manipulator.convertToGrayscale(imageView.image!)
//        
//        //invert
//        imageView.image = manipulator.invertPhoto(imageView.image!)
//        

        
        //load up training pixel data
//                if !hasLoadedTrainingData {
//                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                        // do some task
//                        hasLoadedTrainingData = true
//                        self.trainingPixelData = getContentsOfCSV(trainingSource)
//                        dispatch_async(dispatch_get_main_queue()) {
//                            // update some UI
//                        }
//                    }
//                }
        
        //convert
        
        
        //find characters
        
        //can we load training data yet?
        
        //knn
    }
    
    /*************************************************************
    * MISC FUNCTIONS
    *************************************************************/
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

