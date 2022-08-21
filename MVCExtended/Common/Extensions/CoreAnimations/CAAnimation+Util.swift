import Foundation
import UIKit

public typealias CAAnimationCallback = (CAAnimation, Bool) -> ();

public class CAAnimationCallbacks: NSObject, CAAnimationDelegate {
    
    var startBlock: CAAnimationCallback?
    var completionBlock: CAAnimationCallback?
    
    public func animationDidStart(_ anim: CAAnimation) {
        startBlock?(anim, true)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completionBlock?(anim, flag)
    }
}

public extension CAAnimation {
    
    var startBlock: CAAnimationCallback? {
        get {
            return (delegate as? CAAnimationCallbacks)?.startBlock
        }
        set {
            let delegate = (self.delegate as? CAAnimationCallbacks) ?? CAAnimationCallbacks()
            delegate.startBlock = newValue
            self.delegate = delegate
        }
    }
    
    var completionBlock: CAAnimationCallback? {
        get {
            return (delegate as? CAAnimationCallbacks)?.completionBlock
        }
        set {
            let delegate = (self.delegate as? CAAnimationCallbacks) ?? CAAnimationCallbacks()
            delegate.completionBlock = newValue
            self.delegate = delegate
        }
    }
}
