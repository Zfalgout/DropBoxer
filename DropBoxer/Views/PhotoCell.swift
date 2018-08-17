import UIKit

//This is the representation of the collection view cell.
class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    
    //Configure the cell with the photo from the array and round the corners.
    //This isn't done in awakeFromNib because I don't have the photo yet.
    func configureCellWith(photo: UIImage) {
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        self.imageView.image = photo
        self.imageView.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        checkmark.alpha = 0.0
    }
    
    //A function for showing/hiding the checkmark.
    func updateCheckmark() {
        
        UIView.animate(withDuration: 0.2) {
            if self.checkmark.alpha == 0.0 {
                self.checkmark.alpha = 0.5
            } else {
                self.checkmark.alpha = 0.0
            }
        }
    }
}
