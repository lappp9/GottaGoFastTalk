
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  private let rootVC = CatFeedViewController()

  var firstTime: TimeInterval = 0.0
  var lastTime: TimeInterval = 0.0
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = WindowWithStatusBar(frame: UIScreen.main.bounds)
    let rootNavController = UINavigationController(rootViewController: rootVC)
    
    let font = UIFont(name: "OleoScript-Regular", size: 20.0)!
    rootNavController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font]
    rootNavController.navigationBar.barTintColor = UIColor.white
    rootNavController.navigationBar.isOpaque = true
    rootNavController.navigationItem.titleView?.isOpaque = true
    rootNavController.navigationBar.isTranslucent = false
    window?.rootViewController = rootNavController
    window?.makeKeyAndVisible()
    
    // Add CADisplayLink to track frame drops
    let link = CADisplayLink(target: self, selector: #selector(update(link:)))
    link.add(to: .main, forMode: .commonModes)
    
    return true
  }
  
  @objc func update(link: CADisplayLink) {
    if lastTime == 0 {
      firstTime = link.timestamp
      lastTime = link.timestamp
    }
    
    let currentTime = link.timestamp
    
    let elapsedTime = floor((currentTime - lastTime) * 10_000)/10
    let totalElapsedTime = currentTime - firstTime
    if elapsedTime > 16.7 {
      print("Frame was dropped with elpased time of \(elapsedTime)ms at \(totalElapsedTime)")
    }
    lastTime = link.timestamp
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Set up logging
    let logger = CatLogger()
    logger.reportLogs()
  }
}

