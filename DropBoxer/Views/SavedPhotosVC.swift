import UIKit

class SavedPhotosVC: UIViewController {

    let photoLibrary = PhotoLibraryVM()
    let photoCellImpl = PhotoCell()

    private let reuseIdentifier = "photoCell"
    
    //Using an array for imagesFromLibrary because I need them it to be ordered.  If a user clicks on a cell in the collectionView, that's the image that needs to be uploaded.  Besides, I already ordered the way the photos were retrieved in PhotoLibraryVM.swift.  It'd be a shame to mess it all up now....
    var imagesFromLibrary: [UIImage] = []
    
    //Using a set for images to upload because order doesn't matter as much on upload and because it allows me to remove a *specific* image from the set.  This is done when the user taps a photo, and then goes back and taps it again.
    var imagesForUpload: Set<UIImage> = []
    
    //Grab the width and height of the screen to use to resize the collection view cells.
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.width
    
    @IBOutlet weak var photosCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Grab the photos from the user's photo library.
        imagesFromLibrary = photoLibrary.retrievePhotos()
        
        //Set the collection view's data source and delegate to this VC.
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        //Setup the layout.
        setupCollectionViewLayout()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    
        guard !imagesForUpload.isEmpty else {
            //Show a modal letting the user know that he or she must select an image.
            return
        }

        performSegue(withIdentifier: "showUploadVC", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUploadVC" {
            if let destination = segue.destination as? UploadVC {
                destination.imagesToBeUploaded = self.imagesForUpload
            }
        }
        
    }

}

//This extension is for setting up the collection view layout.
extension SavedPhotosVC {
    
    private func setupCollectionViewLayout() {
        print("Inside of setupCollectionViewLayout")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        photosCollectionView!.collectionViewLayout = layout
    }
    
}

extension SavedPhotosVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("About to return a count of \(imagesFromLibrary.count)")
        return imagesFromLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        //cell.imageView.image = imagesFromLibrary[indexPath.item]
        cell.configureCellWith(photo: imagesFromLibrary[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        
        
        if imagesForUpload.contains(imagesFromLibrary[indexPath.item]) {
            //The images for upload already contains the photo.  Remove it from the array.
            imagesForUpload.remove(imagesFromLibrary[indexPath.item])
            cell?.updateCheckmark()
        } else {
            //The images for upload does not contain the photo.  Add it.
            //imagesForUpload.append(imagesFromLibrary[indexPath.item])
            imagesForUpload.insert(imagesFromLibrary[indexPath.item])
            cell?.updateCheckmark()
        }
        
    }
}
