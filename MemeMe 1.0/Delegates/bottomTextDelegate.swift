//
//  bottomTextDelegate.swift
//  
//
//  Created by Timothy Isenman on 12/29/17.
//  Copyright © 2017 Timothy Isenman. All rights reserved.
//

import Foundation
import UIKit

class bottomTextDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = MemeEditorViewController()
        
        //Clearing the TextField text after user selection
        if textField.text == vc.bottomStartingText {
            textField.text = ""
        } else {
            return
        }
    }
    
    //Hiding the Keyboard after a user hits Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
