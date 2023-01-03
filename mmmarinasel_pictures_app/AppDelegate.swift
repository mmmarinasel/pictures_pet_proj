import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        let firstVC = PicturesViewController()
        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let secondVC = FavoritesViewController()
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        tabBarController.setViewControllers([firstVC, secondVC], animated: false)
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor(white: 1, alpha: 0.6)
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}

