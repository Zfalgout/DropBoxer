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
        //This is checked at the end of each iteration through the loop.  It will stop further uploads if we had an error.
        var shouldBreak = false
        
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
                            self.delegate?.updateUploadMessageWith(success: true, count: count)
                        } else if let error = error {
                            //Handle all upload errors here.
                            //Something failed.  Handle it.
                            self.delegate?.updateUploadMessageWith(success: false, count: photos.count)
                            //If we've gotten here, then we want to break out of the for loop and stop all future uploads, set a variable to do that.
                            shouldBreak = true
                            
                            //Reset count such that the count passed in to the updateProgressBar method never equals the correct number.
                            count = 0
                        }
                    }
                    .progress { progressData in
                        //Do anything if you want to monitor an individual upload's progress.
                        }
            } else {
                //Handle the conversion error.
            }
            
            //Check whether we should break out of the loop.  Should only happen on errors.
            if shouldBreak {
                break
            }
        }
    }
    
}
