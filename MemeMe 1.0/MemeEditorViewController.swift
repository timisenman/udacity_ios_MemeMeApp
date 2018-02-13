//
//  ViewController.swift
//  
//
//  Created by Timothy Isenman on 12/27/17.
//  Copyright © 2017 Timothy Isenman. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: UI Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var bottomNavBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var actionOutlet: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigtion: UINavigationBar!
    
    
    //MARK: Declarations
    let imagePicker = UIImagePickerController()
    let topText = topTextDelegate()
    let bottomText = bottomTextDelegate()
    let topStartingText = "TOP"
    let bottomStartingText = "BOTTOM"
    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    //MARK: Configurations
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        self.view.backgroundColor = UIColor.black
        
        //TextField configurations
        configure(textField: topTextField, withDelegate: topText, withStartingText: topStartingText)
        configure(textField: bottomTextField, withDelegate: bottomText, withStartingText: bottomStartingText)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToNotifications()
        
        //Hiding Share button
        actionOutlet.isEnabled = self.imageView.image != nil
        
        //Disable Camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        memes = appDelegate.memes
        print("\nMeme Editor memes:\n\(memes!)\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToNotifications()
    }
    
    // Font and TextField attributes
    func configure(textField: UITextField, withDelegate delegate:UITextFieldDelegate, withStartingText: String) {
        textField.delegate = delegate
        
        //Programmatic Font configuration for TextFields
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBold", size: 60)!]
        
        
        textField.text = withStartingText
    
        textField.defaultTextAttributes = memeTextAttributes
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = CGFloat(12.0)
        textField.textAlignment = .center
    }
    
    
    //MARK: Subscription to Notifications
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        print("Observer added")
    }
    
    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        print("Observer removed")
    }
    
    //MARK: Getting and adjusting keyboard height
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        print("Keyboard height set")
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
        view.frame.origin.y = getKeyboardHeight(notification) - getKeyboardHeight(notification)
        print("Keyboard height reset")
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    //MARK: Button Functions
    //User selects Album in the Meme editor
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        if sourceType == .camera {
            print("Camera selected")
        } else {
            print("Album selected")
        }
    }
    
    
    @IBAction func pickImageFromAlbumButton(_ sender: Any) {
        pickAnImageFrom(sourceType: .photoLibrary)

    }
    
    //User selects Camera in Meme editor
    @IBAction func pickImageFromCameraButton(_ sender: Any) {
        pickAnImageFrom(sourceType: .camera)

    }
    
    //Reset Meme editor fields: Top and Bottom textfields, and the Image
    @IBAction func cancelMemeEdit(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        actionOutlet.isEnabled = false
        navigationController?.popViewController(animated: true)
        print("Editing cancelled")
    }
    
    //Generate image from user's Meme configuration
    func generateMemeImage() -> UIImage {
        
        showToolBars(true)
        
        //Select area of screen to save
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showToolBars(false)
        
        return memedImage
    }
    
    func showToolBars(_ bool: Bool) {
        bottomNavBar.isHidden = bool
        navigtion.isHidden = bool
    }

    //Saving meme in data model
    func save() {
        let newMemedImage = generateMemeImage()
        print("Save started")
        let meme = Meme(bottomText: bottomTextField.text!, topText: topTextField.text!, originalImage: imageView.image!, memedImage: newMemedImage, memeName: "\(topTextField.text!)...\(bottomTextField.text!)")
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print("******Current memes saved: \n\(appDelegate.memes)*******\n*******End of memes*******")
        print("Save finished")
    }
    
    
    
    //Save and take action on the new meme
    @IBAction func actionButton(_ sender: Any) {
        print("\"Share\" pressed")
        
        //MARK: Save image to Camera Roll
        let newMemedImage = generateMemeImage()
        
        //MARK: Present ActivityView
        //Instation ActivityViewController
        let activityView = UIActivityViewController(activityItems: [newMemedImage], applicationActivities: nil)
        self.present(activityView, animated: true, completion: nil)
        
        
        //Save image with a successful action
        activityView.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                UIImageWriteToSavedPhotosAlbum(newMemedImage, nil, nil, nil)
                print("Action complete\nImage saved")
                self.save()
                //print("Meme image info: \(String(describing: meme.memedImage))\nTop Text: \(String(describing: meme.topText))\nBottom Text: \(String(describing: meme.bottomText))")
            } else {
                print("User cancelled Action selection\nImage not saved")
            }
        }
        
        print("Image ready to share")
    }
    
    //MARK: Image Picker Delegate Functions
    //Allow users to select an image from their Albums
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //Dismiss the image selection screen if a user cancels
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Dismiss the keyboard when a user presses Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

