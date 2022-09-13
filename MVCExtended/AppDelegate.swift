
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var mvcCoordinator: MVCCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        mvcCoordinator = MVCCoordinator(window: window!)
        mvcCoordinator.showFirstScreen()
        
        return true
    }
    
    
}

