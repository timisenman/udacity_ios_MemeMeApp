import Foundation
import UIKit

struct Meme {
    let bottomText: String?
    let topText: String?
    let originalImage: UIImage?
    let memedImage: UIImage
    var memeName: String {
        return "\(topText!)...\(bottomText!)"
    }
}
