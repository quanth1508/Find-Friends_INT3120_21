import UIKit


extension UIViewController {
    
    var topMostViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.topMostViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.topMostViewController ?? self
        default:
            return presentedViewController?.topMostViewController ?? self
        }
    }
    
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}

public extension UIApplication {
    static var topViewController : UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController
    }
}
