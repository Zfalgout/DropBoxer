import UIKit

protocol DropboxVMDelegate {
    func updateUploadMessageWith(success: Bool, count: Int)
    func updateProgressLabel(inLoop: Bool)
}

//This is the view that calls over to the DropboxVM backend.  All it exists to do is shuttle information.
class UploadVC: UIViewController, DropboxVMDelegate {

    //The images to be uploaded.
    var imagesToBeUploaded: Set<UIImage> = []
    
    //The object used to connect to dropbox.
    var dropboxVM = DropboxVM()
    
    //The circle to animate
    let shapeLayer = CAShapeLayer()
    
    //The view that holds the success message.  It starts out as hidden and will be shown upon download completion.
    @IBOutlet weak var uploadMessageView: UIView!
    @IBOutlet weak var uploadMessageLabel: UILabel!
    @IBOutlet weak var checkmarkImg: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var uploadBtn: RoundedButtonView!
    
    //The view that holds the button for uploading more photos.
    @IBOutlet weak var uploadMorePhotosView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropboxVM.delegate = self
        
        progressCircleSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //If the user isn't authenticated, then attempt to authenticate.
        if !userAuthenticated {
            dropboxVM.authenticateWithDB(from: self)
        }
    }
    
    //This function will update the progress bar and upload message depending on whether each photo's upload was successful or not.
    internal func updateUploadMessageWith(success: Bool, count: Int) {
        
        let newStrokeLength = Double(count)/Double(imagesToBeUploaded.count)
        shapeLayer.strokeEnd = CGFloat(newStrokeLength)

        //Success path.
        if success {
            //If all photos to be uploaded have been, then show the success message.  The UI is set up to handle successes initially so no other changes need to be made.
            if count/imagesToBeUploaded.count == 1 {
                showUploadMessage()
                
                //On success ALSO ask the user if he or she would like to upload more photos.
                UIView.animate(withDuration: 0.5) {
                    self.uploadMorePhotosView.alpha = 1.0
                }
            }
        } else {
            //Error path.
            //Update the UI to show the user an error has occurred. 
            uploadMessageLabel.text = "There was an error on upload.  Please try again later."
            uploadMessageView.backgroundColor = UIColor.red
            checkmarkImg.image = #imageLiteral(resourceName: "X mark")
            shapeLayer.strokeColor = UIColor.red.cgColor
            
            showUploadMessage()
        }
    }

    internal func updateProgressLabel(inLoop: Bool) {
        if inLoop {
            progressLabel.text = "Upload progress"
        } else {
            progressLabel.text = "Please wait..."
        }
    }
    
    fileprivate func showUploadMessage() {
        //Fade the message in.
        UIView.animate(withDuration: 0.5) {
            self.uploadMessageView.alpha = 1.0
        }
    }
    
    //A convienince function to set up the progress circle.
    fileprivate func progressCircleSetup() {
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
    
    //Upload the photos.
    @IBAction func uploadPhotos(_ sender: Any) {
        //After the button is clicked, disable it.  I don't want users re-uploading the same photos.
        uploadBtn.isEnabled = false
        uploadBtn.backgroundColor = UIColor.gray
        uploadBtn.alpha = 0.5
        
        dropboxVM.upload(photos: imagesToBeUploaded)
    }
    
    //Button to dismiss the current view and route the user back to the collection view.
    @IBAction func uploadMorePhotosTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

