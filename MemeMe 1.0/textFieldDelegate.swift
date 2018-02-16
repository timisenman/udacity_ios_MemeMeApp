import Foundation
import UIKit

class textFieldDelegate: NSObject, UITextFieldDelegate {
    func updateText(_ textField: UITextField){
        let vc = MemeEditorViewController()
        if textField.text == vc.bottomStartingText || textField.text == vc.topStartingText {
            textField.text = ""
        } else {
            return
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateText(textField)
    }
    
    //Hiding the Keyboard after a user hits Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

