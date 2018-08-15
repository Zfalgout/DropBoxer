import UIKit

//This is the initial view controller a user sees when entering the app.  It allows the user to choose a photo (or photos) he or she wishes to upload to Dropbox.  The photo library functionality is gained through the use of a UIImagePickerController, with this class being set as its delegate.  This class must also conform to UINavigationControllerDelegate because UIImagePickerController's delegate property is inherited from UINavigationController.
class SavedPhotosVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //Our instance of the UIImagePickerController.
    let imagePicker = UIImagePickerController()
    
    var imageArray: [UIImage] = []
    var usedImageURLs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the source as the saved photos album.  This could also be set to either the camera or the photo library.
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        
        present(imagePicker, animated: false, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("ZACK: The info is \(info)")
        //Attempt to convert the information in the info dictionary's UIImagePickerControllerOriginalImage key to an image
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            //Need to think about how I want to handle failures.
            print("Couldn't convert the info to a UIImage, returning")
            return
        }
        
        //Grab the photo's reference URL.  I'm allowing the user to upload multiple photos at a time, this is how I make sure that the same photo isn't upload twice by mistake.
        guard let photoURL = info["UIImagePickerControllerReferenceURL"] as? URL else {
            print("Couldn't convert the image url value to a URL")
            return
        }
        
        //If the reference URL is not in the usedImageURLs array, then it's a new photo the user wants to upload.
        if !usedImageURLs.contains(photoURL){
            
            //Append the image to both arrays.
            imageArray.append(image)
            usedImageURLs.append(photoURL)
        }

        print("The imageArray is now \(imageArray)")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
