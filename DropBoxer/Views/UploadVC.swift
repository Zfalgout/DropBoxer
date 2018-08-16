import UIKit
import SwiftyDropbox

//This is the view that calls over to the DropboxVM backend.  All it exists to do is shuttle information.
class UploadVC: UIViewController {

    //The images to be uploaded.
    var imagesToBeUploaded: Set<UIImage> = []
    
    //The object used to connect to dropbox.
    let dropboxVM = DropboxVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !userAuthenticated {
            dropboxVM.authenticateWithDB(from: self)
        }
    }
    
    @IBAction func uploadPhotos(_ sender: Any) {
    
        print("The photos to be uploaded are \(imagesToBeUploaded)")
        
        //dropboxVM.authenticateWithDB(from: self)
        
        dropboxVM.upload(photos: imagesToBeUploaded)
    }
}
