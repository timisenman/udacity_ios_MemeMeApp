//
//  testDelegate.swift
//  memeMe
//
//  Created by Timothy Isenman on 2/15/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation
import UIKit

class textFieldDelegate: NSObject, UITextFieldDelegate {
    func updateBottomText(_ textField: UITextField){
        let vc = MemeEditorViewController()
        if textField.text == vc.bottomStartingText {
            textField.text = ""
        } else {
            return
        }
    }
    
    func updateTopText(_ textField: UITextField){
        let vc = MemeEditorViewController()
        if textField.text == vc.topStartingText {
            textField.text = ""
        } else {
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clearing the TextField text after user selection
        updateTopText(textField)
        updateBottomText(textField)
    }
    
    //Hiding the Keyboard after a user hits Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

