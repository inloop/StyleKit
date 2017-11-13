import UIKit
import StyleKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let styleFile = Bundle.main.url(forResource: "style", withExtension: "json") {
            
            let config = StyleKitConfig(styleFile) {
                    $0.logLevel = .debug
                    $0.moduleName = "StyleKitDemo"
                    $0.watchForChanges = true
                }
            
            // Uses default style parser
            StyleKit(config)?.apply()
            
        }
        return true
    }

}

