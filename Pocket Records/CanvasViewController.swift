//
//  CanvasViewController.swift
//  Pocket Records
//
//  Created by Kya Suzuki on 7/18/17.
//  Copyright © 2017 Kya Suzuki. All rights reserved.
//

import UIKit
import os.log

class CanvasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var song: Song?
    
    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var drawImageView: UIImageView!
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.textView.delegate = self


        // Set up views if editing an existing Song.
        if let song = song {
            navigationItem.title = song.songTitle
            photoImageView.image = song.canvasImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the picker if user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    
    func cameraPopup() {
        let camera = CameraHandler(delegate_: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    // MARK: DrawImageView
    
    
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.drawImageView)
        }
    }
    
    func drawLines(fromPoint:CGPoint, toPoint:CGPoint){
    UIGraphicsBeginImageContext(self.drawImageView.frame.size)
        drawImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawImageView.frame.width, height: self.drawImageView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first{
            let currentPoint = touch.location(in: self.drawImageView)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    // MARK: Text View
    
       
//    func textViewImage() -> UIImage {
//        
//        UIGraphicsBeginImageContext(textView.contentSize)
//        
//        let savedContentOffset: CGPoint = textView.contentOffset
//        let savedFrame: CGRect = textView.frame
//        
//        textView.contentOffset = CGPoint.zero
//        textView.frame = CGRect(x:0 , y: 0, width: textView.contentSize.width, height: textView.contentSize.height)
//        
//        textView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        
//        textView.contentOffset = savedContentOffset
//        textView.frame = savedFrame
//        
//        UIGraphicsEndImageContext()
//        
//        return image!
//    }
    
     //dismisses keyboard when press return on toggle keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddSongMode = presentingViewController is UINavigationController
        
        // when adding a song but cancel
        if isPresentingInAddSongMode {
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
        // when editing a song's canvas but cancel
        owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The CanvasViewController is not inside a navigation controller.")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if (photoImageView.isHidden == false){
        let photo = photoImageView.image
        song?.canvasImage = photo
        }else if (drawImageView.isHidden == false){
            let photo = drawImageView.image
            song?.canvasImage = photo
        }
        else
        { let photo = UIImage(named: "default")
        song?.canvasImage = photo
        }
        
        
        // only passing the canvasImage so don't need to worry about passing the entire song object -->
        //let defaultImage = UIImage(named: "default")
        // Set the song to be passed to SongTableViewController after the unwind segue.
        //song = Song(songTitle: "Song Title", songArtist: "Song Artist", albumImage: defaultImage, canvasImage: photo)
        // may just need to pass the canvas image? may need to pass it all? do i need to pass it as a song??????????????????????????
    }
    
    // MARK: Actions
    
    
    @IBAction func cameraHandler(_ sender: UIBarButtonItem) {
        drawImageView.isHidden = true
        textView.isHidden = true
        photoImageView.isHidden = false
        cameraPopup()

    }
    
    @IBAction func textHandler(_ sender: UIBarButtonItem) {
        photoImageView.isHidden = true
        drawImageView.isHidden = true
        textView.isHidden = false
        textView.becomeFirstResponder()

    }
    
    
    @IBAction func drawHandler(_ sender: UIBarButtonItem) {
        photoImageView.isHidden = true
        textView.isHidden = true
        drawImageView.isHidden = false
    }
    
    
    
}
