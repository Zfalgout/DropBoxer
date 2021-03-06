import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        //Initialize a DropboxClient instance
        DropboxClientsManager.setupWithAppKey("ybr6sblgt4jysvh")
        
        return true
    }

    //The following code handles the redirect back into the SDK from Dropbox.
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                userAuthenticated = true
            case .cancel:
                print("User cancelled")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        return true
    }

}

//This exists so that the authentication criteria can be communicated to the uploadVC after the authentication flow takes place.
var userAuthenticated = false
