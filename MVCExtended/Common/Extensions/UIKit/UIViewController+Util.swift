import UIKit

extension UIViewController {
    
    var descendantViewControllers: [UIViewController] {
        return [self] + children.map { $0.descendantViewControllers }.joined()
    }
    
}
