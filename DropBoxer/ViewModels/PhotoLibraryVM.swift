import Foundation
import Photos

//This struct is responsible for accessing the user's photo library.
struct PhotoLibraryVM {
    
    func retrievePhotos() -> [StatefulImage] {
        var imageArray: [StatefulImage] = []
        let imageManager = PHImageManager.default()
        
        //The options for requesting the photos.  Could synchronous cause issues?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
        
        //Create a fetchOptions object to sort the way we retrieve the photos.
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        //Making the 'with' parameter .image means that we shouldn't get any movies.
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            for i in 0..<fetchResult.count {
                imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { (image, dictionary) in
                    
                    //Create a statefulImage object using the image.
                    if let appendedImage = image {
                        imageArray.append(StatefulImage(photo: appendedImage, isChecked: false))
                    }
                }
            }
        } else {
            print("There are no photos to upload to Dropbox.")
        }

        return imageArray
    }
    
}

