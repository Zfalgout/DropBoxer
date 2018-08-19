//Have to import UIKit to get access to UIImage.
import UIKit

class StatefulImage {
    
    let photo: UIImage!
    var isChecked: Bool!
    
    init(photo: UIImage, isChecked: Bool) {
        self.photo = photo
        self.isChecked = isChecked
    }
}
