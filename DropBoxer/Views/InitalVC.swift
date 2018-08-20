import UIKit
import Photos

class InitalVC: UIViewController {

    let photoLibrary = PhotoLibraryVM()
    var imagesFromLibrary: [StatefulImage] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deniedMessage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the authroization status of the photo library.
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .notDetermined {
            self.requestAuthorization()
        } else if photos == .authorized {
            self.goToCollectionView()
        } else if photos == .denied {
            print("Authorization denied.")
            self.requestAuthorization()
            //I'd like to ask for authorization again, but when I do the status object in requestAuthorization is .denied already so nothing happens.
        }
    }
    
    private func goToCollectionView() { 
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showCollection", sender: self)
        }
    }
    
    private func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                DispatchQueue.main.async {
                    self.goToCollectionView()
                }
            } else {
                //The status has been set to denied, show a popup letting the user know how to give access to DropBoxer for their photos.
                DispatchQueue.main.async {
                    self.deniedMessage.isHidden = false
                }
            }
        })
    }
}
