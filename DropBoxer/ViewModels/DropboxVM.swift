import Foundation
import SwiftyDropbox

//This struct is responsible for making the calls out to Dropbox.
struct DropboxVM {
    
    var delegate: DropboxVMDelegate?
    
    //This is the function called for authenticating the user with Dropbox.
    func authenticateWithDB(from view: UIViewController) {
        
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: view,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.openURL(url)
        })
    }
    
    func upload(photos: Set<UIImage>) {

        print("Uploading the photos to dropbox now \(photos)")

        //The user has been authorized.  Create a dropbox client using the authroized info.
        let client = DropboxClientsManager.authorizedClient

        //Get today's date to use as the name of the upload folder.
        let uploadDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy_MM_dd"
        //Append a UUID at the end so as not to cause any collisions.
        let folderName = formatter.string(from: uploadDate) + "_" + UUID().uuidString
        
        var count = 0
        
        //Loop through our set of photos.
        for photo in photos {
            count += 1
            //Convert the photo to data for upload.
            if let fileData = UIImagePNGRepresentation(photo) {

                //Names must be unique in dropbox.  Create a UUID for each photo so there aren't any collisions.
                let photoName = "Dropboxer photo" + UUID().uuidString
                //Upload the photo.
                let request = client?.files.upload(path: "/DropboxerUploads/\(folderName)/\(photoName).png", input: fileData)
                    .response { response, error in
                        //The call to DB has been made.
                        if let response = response {
                            //Check the response for any needed data.
                            //print("The response is \(response)")
                        } else if let error = error {
                            //Handle all upload errors here.
                            //Something failed.  Handle it.
                            //print(error)
                        }
                    }
                    .progress { progressData in
                        //Create and show a progress bar here.
                        self.delegate?.updateProgressBar(count: count)
                        }
            } else {
                //Handle the conversion error.
            }
        }

    }
    
}
