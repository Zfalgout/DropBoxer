import UIKit

//This is the representation of the collection view cell.
class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //Configure the cell with the photo from the array and round the corners.
    func configureCellWith(photo: UIImage) {
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        self.imageView.image = photo
        self.imageView.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
    
}
