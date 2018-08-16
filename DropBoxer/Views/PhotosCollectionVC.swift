import UIKit

class PhotosCollectionVC: UIViewController {

    //This class was obseleted when I stopped using a container view inside of the SavedPhotosVC to hold the images.
    //The button needed access to the imagesToUpload array, and instead of making that attribute global, I just moved the entire collection view functionality over.  I feel that the extra overhead in SavedPhotosVC is worth not having a global attribute for the most important part of the app.

}
