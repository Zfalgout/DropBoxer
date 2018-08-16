import Foundation
import SwiftyDropbox

//This struct is responsible for making the calls out to Dropbox.
struct DropboxVM {
    
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

        //Loop through our set of photos.
        for photo in photos {
            //Convert the photo to data for upload.
            if let fileData = UIImagePNGRepresentation(photo) {
                //Names must be unique in dropbox.  Create a UUID for each photo so there aren't any collisions.
                let photoName = "Dropboxer photo" + UUID().uuidString
                //Upload the photo.
                let request = client?.files.upload(path: "/DropboxerUploads/\(photoName).png", input: fileData)
                    .response { response, error in
                        //The call to DB has been made.
                        if let response = response {
                            //Check the response for any needed data.
                            print(response)
                        } else if let error = error {
                            //Handle all upload errors here.
                            //Something failed.  Handle it.
                            print(error)
                        }
                    }
                    .progress { progressData in
                        //Create and show a progress bar here.
                        print("In the progress block.")
                        print(progressData)
                }
            } else {
                //Handle the conversion error.
            }
        }
    }
    
}
