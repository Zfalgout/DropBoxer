import UIKit

class RoundedButtonView: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    //Function to setup how the button looks.
    private func configureView() {
        //Round the edges so it forms a pill.
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 2 / UIScreen.main.nativeScale
        layer.borderColor = UIColor.white.cgColor
    }
}
