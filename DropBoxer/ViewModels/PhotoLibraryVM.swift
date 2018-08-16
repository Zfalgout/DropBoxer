import Foundation
import Photos

struct PhotoLibraryVM {
    
    func retrievePhotos() -> [UIImage] {
        var imageArray: [UIImage] = []
        let imageManager = PHImageManager.default()
        
        //The options for requesting the photos.  Could synchronous cause issues?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
        
        //Create a fetchOptions object to sort the way we retrieve the photos.
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        //Do I need to check whether the fetch was successful?
        
        if fetchResult.count > 0 {
            
            for i in 0..<fetchResult.count {
                imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { (image, dictionary) in
                    imageArray.append(image!)
                }
            }
            
        } else {
            print("There are no photos to upload to Dropbox.")
        }

        return imageArray
    }
    
}

