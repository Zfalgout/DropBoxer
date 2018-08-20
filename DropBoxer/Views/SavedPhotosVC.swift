import UIKit

class SavedPhotosVC: UIViewController {

    //String value to determine if the alert is shown.
    private let SHOW_INSTRUCTION_ALERT_KEY = "ShowInstructionAlert"
    private let reuseIdentifier = "photoCell"
    
    let photoLibrary = PhotoLibraryVM()
    let userDefaults = UserDefaults()
    let photoCellImpl = PhotoCell()
    
    //Using an array for imagesFromLibrary because I need them it to be ordered.  If a user clicks on a cell in the collectionView, that's the image that needs to be uploaded.  Besides, I already ordered the way the photos were retrieved in PhotoLibraryVM.swift.  It'd be a shame to mess it all up now....
    var imagesFromLibrary: [StatefulImage] = []
    
    //Using a set for images to upload because order doesn't matter as much on upload and because it allows me to remove a *specific* image from the set.  This is done when the user taps a photo, and then goes back and taps it again.
    var imagesForUpload: Set<UIImage> = []
    
    var checkedImages: Set<Int> = []
    
    //Grab the width and height of the screen to use to resize the collection view cells.
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.width
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Grab the photos from the user's photo library.
        imagesFromLibrary = photoLibrary.retrievePhotos()
        
        //Set the collection view's data source and delegate to this VC.
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        //Setup the layout.
        setupCollectionViewLayout()
        
        //Set up a notification to show the alert if the application becomes active from the background.
        NotificationCenter.default.addObserver(self, selector:#selector(determineIfAlertIsShown), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    //Override viewDidAppear to show the alert.
    override func viewDidAppear(_ animated: Bool) {
        //Need to see if we have to show the alert.
        determineIfAlertIsShown()
        
        //Ensure the countLabel is white and the correct size.
        removeCountIssue()
        
        //If an image was previously uploaded, it needs its isChecked attribute flipped to false if this view appears again.
        for index in checkedImages {
            imagesFromLibrary[index].isChecked = false
        }
        
        //Clear out the imagesForUpload array.
        imagesForUpload.removeAll()
        
        //Hide the checkmark for each selected cell.
        photosCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func determineIfAlertIsShown() {
        //The only time this key in UserDefaults is sets is after the user clicks the option to not be shown the instructions again.  If it is anything but nil, show the alert.
        guard userDefaults.string(forKey: SHOW_INSTRUCTION_ALERT_KEY) != nil else {
            showAlert()
            return
        }
        
        //This is a safety net in case the guard statement fails somehow (e.g. if the value for this key gets changed at some point in the future).
        if userDefaults.string(forKey: SHOW_INSTRUCTION_ALERT_KEY) != "no" {
            showAlert()
        }
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: nil, message: "Please select up to 20 photos", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        //This will add an entry to user defaults which can then be read on subsequent loads of the app.
        alert.addAction(UIAlertAction(title: "Don't show me this again", style: .destructive, handler: { [weak self] alert in
            self?.userDefaults.set("no", forKey: (self?.SHOW_INSTRUCTION_ALERT_KEY)!)
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    
        if imagesForUpload.isEmpty {
            //Pop the countLabel up some and change it's color so the user knows what the problem is.
            showCountIssue()
            return
        } else {
            performSegue(withIdentifier: "showUploadVC", sender: self)
        }
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
        return imagesFromLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        //cell.imageView.image = imagesFromLibrary[indexPath.item]
        cell.configureCellWith(statefulImage: imagesFromLibrary[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        
        if imagesForUpload.contains(imagesFromLibrary[indexPath.item].photo) {
            
            //If the user had previously attempted to add a twenty-first picture, then the countLabel will show an error.  If the user attempts to remove one of the twenty pictures then we need to reset the countLabel.
            if countLabel.textColor == UIColor.red {
                removeCountIssue()
            }
            
            //The images for upload already contains the photo.  Remove it from the array.
            imagesForUpload.remove(imagesFromLibrary[indexPath.item].photo)
            
            //Ensure that the cell is a PhotoCell and isn't nil.
            guard let cell = cell else {
                //The cell was nil, the image has been added to the upload array, return without showing a checkmark.
                return
            }
            
            //Toggle the checkmark.
            cell.updateCheckmarkFor(statefulImage: imagesFromLibrary[indexPath.item])
            //Remove the image from the array that holds the indicies of the checked images.
            checkedImages.remove(indexPath.item)
            //Update the count.
            countLabel.text = "\(imagesForUpload.count)"
        } else {
            
            guard imagesForUpload.count < 20 else {
                showCountIssue()
                return
            }
            
            //The images for upload does not contain the photo.  Add it.
            //imagesForUpload.append(imagesFromLibrary[indexPath.item])
            imagesForUpload.insert(imagesFromLibrary[indexPath.item].photo)
            
            //If the color of the label is red then the user previously attempted to get to the upload screen without adding photos to be uploaded.  Now that the user has selected a photo, return the label to its original configuration.
            if countLabel.textColor == UIColor.red {
                removeCountIssue()
            }
            
            //Ensure that the cell is a PhotoCell and isn't nil.
            guard let cell = cell else {
                //The cell was nil, the image has been added to the upload array, return without showing a checkmark.
                return
            }
            cell.updateCheckmarkFor(statefulImage: imagesFromLibrary[indexPath.item])
            checkedImages.insert(indexPath.item)
            countLabel.text = "\(imagesForUpload.count)"
        }
        
    }
    
    //The following two functions are convience functions for adding/removing the countLabel
    private func showCountIssue() {
        UIView.animate(withDuration: 0.25) {
            self.countLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.countLabel.textColor = UIColor.red
        }
    }
    
    private func removeCountIssue() {
        if countLabel.textColor == UIColor.red {
            UIView.animate(withDuration: 0.25) {
                self.countLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.countLabel.textColor = UIColor.white
            }
        }
    }
}
