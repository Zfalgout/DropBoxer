import Foundation
import SwiftyDropbox


//This struct is responsible for making the calls out to Dropbox.
struct DropboxVM {
    
    //This is the function called for authenticating the user with Dropbox.
    func authenticateWithDB(from view: UIViewController) {
        
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: view,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.openURL(url)
        })
        
    }
    
}
