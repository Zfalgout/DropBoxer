import UIKit
import SwiftyDropbox

protocol DropboxVMDelegate {
    func updateSuccessMessage()
    func updateProgressBar(count: Int)
}

//This is the view that calls over to the DropboxVM backend.  All it exists to do is shuttle information.
class UploadVC: UIViewController, DropboxVMDelegate {

    //The images to be uploaded.
    var imagesToBeUploaded: Set<UIImage> = []
    
    //The object used to connect to dropbox.
    var dropboxVM = DropboxVM()
    
    //The circle to animate
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropboxVM.delegate = self
        
        //let center = view.center
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: (CGFloat.pi * 2), clockwise: true)
        
        let trackLayer = CAShapeLayer()
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.position = view.center
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.position = view.center
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        //Rotate the filled layer such that the progress bar matches the download percent.  Without this the download bar is larger than the associated percent.
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !userAuthenticated {
            dropboxVM.authenticateWithDB(from: self)
        }
    }
    
    func updateSuccessMessage() {
        
    }
    
    func updateProgressBar(count: Int) {
        print("Update progress bar has been called.")
        shapeLayer.strokeEnd = CGFloat(count/imagesToBeUploaded.count)
    }
    
    @IBAction func uploadPhotos(_ sender: Any) {
    
        print("The photos to be uploaded are \(imagesToBeUploaded)")

        dropboxVM.upload(photos: imagesToBeUploaded)
        
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        
//        basicAnimation.toValue = 1
//        
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = kCAFillModeForwards
//        basicAnimation.isRemovedOnCompletion = false
//        
//        shapeLayer.add(basicAnimation, forKey: "uploadProgress")
    }
}

