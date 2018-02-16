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
    let textField = textFieldDelegate()
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
        configure(textField: topTextField, withDelegate: textField, withStartingText: topStartingText)
        configure(textField: bottomTextField, withDelegate: textField, withStartingText: bottomStartingText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        subscribeToNotifications()
        
        //Hiding Share button
        actionOutlet.isEnabled = self.imageView.image != nil
        
        //Disable Camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
    }
    
    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Getting and adjusting keyboard height
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Button Functions
    //User selects Album in the Meme editor
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
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
        dismiss(animated: true, completion: nil)
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
        let meme = Meme(bottomText: bottomTextField.text!, topText: topTextField.text!, originalImage: imageView.image!, memedImage: newMemedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //Save and take action on the new meme
    @IBAction func actionButton(_ sender: Any) {
        //MARK: Save image to Camera Roll
        let newMemedImage = generateMemeImage()
        
        //MARK: Present ActivityView
        let activityView = UIActivityViewController(activityItems: [newMemedImage], applicationActivities: nil)
        self.present(activityView, animated: true, completion: nil)
        
        activityView.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
            } else {
                print("User cancelled Action selection\nImage not saved")
            }
        }
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
}

