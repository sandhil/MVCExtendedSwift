import UIKit
import SwifterSwift

typealias LayerState = [String : Any?]

fileprivate extension Dictionary where Key == String, Value == Any? {
    
    var superlayer: CALayer? {
        get {
            return self["superlayer"] as? CALayer
        }
        set {
            self["superlayer"] = newValue
        }
    }
    
    var isHidden: Bool {
        get {
            return self[#keyPath(CALayer.isHidden)] as! Bool
        }
        set {
            self[#keyPath(CALayer.isHidden)] = newValue
        }
    }
    
    var frame: CGRect {
        get {
            return self["frame"] as! CGRect
        }
        set {
            self["frame"] = newValue
        }
    }
    
    var backgroundColor: CGColor? {
        get {
            let value = self["backgroundColor"]
            guard CFGetTypeID(value as CFTypeRef) == CGColor.typeID else {
                return nil
            }
            return (value as! CGColor)
        }
        set {
            self["backgroundColor"] = newValue
        }
    }
    
    var opacity: Float {
        get {
            return self["opacity"] as! Float
        }
        set {
            self["opacity"] = newValue
        }
    }
    
    var shadowPath: CGPath? {
        get {
            let value = self["shadowPath"]
            guard CFGetTypeID(value as CFTypeRef) == CGPath.typeID else {
                return nil
            }
            return (value as! CGPath)
        }
        set {
            self["shadowPath"] = newValue
        }
    }
    
    var shadowOpacity: Float {
        get {
            return self["shadowOpacity"] as! Float
        }
        set {
            self["shadowOpacity"] = newValue
        }
    }
    
    var shadowColor: CGColor? {
        get {
            let value = self["shadowColor"]
            guard CFGetTypeID(value as CFTypeRef) == CGColor.typeID else {
                return nil
            }
            return (value as! CGColor)
        }
        set {
            self["shadowColor"] = newValue
        }
    }
    
    var shadowOffset: CGSize {
        get {
            return self["shadowOffset"] as! CGSize
        }
        set {
            self["shadowOffset"] = newValue
        }
    }
    
    var shadowRadius: CGFloat {
        get {
            return self["shadowRadius"] as! CGFloat
        }
        set {
            self["shadowRadius"] = newValue
        }
    }
    
    var path: CGPath? {
        get {
            let value = self["path"]
            guard CFGetTypeID(value as CFTypeRef) == CGPath.typeID else {
                return nil
            }
            return (value as! CGPath)
        }
        set {
            self["path"] = newValue
        }
    }
    
    var fillColor: CGColor? {
        get {
            let value = self["fillColor"]
            guard CFGetTypeID(value as CFTypeRef) == CGColor.typeID else {
                return nil
            }
            return (value as! CGColor)
        }
        set {
            self["fillColor"] = newValue
        }
    }
}

extension UIView {
    
    func animateToCurrentLayout(duration: TimeInterval = 0.25, from beforeStates: [CALayer : LayerState], excluding nonAnimatingViews: [UIView] = [], excludingChildrenOf parentsOfNonAnimatingViews: [UIView] = []) {
        
        let beforeLayers = Array(beforeStates.keys)
        
        let nonAnimatingLayers = (nonAnimatingViews.map { $0.layer } + (nonAnimatingViews + parentsOfNonAnimatingViews).flatMap { $0.layer.descendantLayers })
            .distinct()
        
        beforeLayers
            .filter { $0 ∉ nonAnimatingLayers }
            .forEach { $0.removeAllAnimations() }
        
        layoutIfNeeded()
        
        let afterStates = recordState()
        let afterLayers = Array(beforeStates.keys)
        
        let layers = (beforeLayers + afterLayers)
            .distinct()
            .filter { !nonAnimatingLayers.contains($0) }
        
        if layers.isEmpty {
            return
        }
        
        CATransaction.begin()
        
        layers.forEach { layer in
            
            let beforeState = beforeStates[layer]
            let afterState = afterStates[layer]
            
            let isAdded = (beforeState == nil || beforeState!.isHidden) && (afterState != nil && !afterState!.isHidden)
            let isRemoved = (beforeState != nil && !beforeState!.isHidden) && (afterState == nil || afterState!.isHidden)
            
//            view.isHidden = false // Commented out because it messes up animations / state for StackViews
            
            // Commented out because it causes a BAD_ACCESS somehow in combination with Hero
//            if afterState == nil {
//                beforeState!.superlayer?.addSublayer(layer)
//            }
            
            let beforeFrame: CGRect
            let afterFrame: CGRect
            let beforeOpacity: Float
            let afterOpacity: Float
            
            if isAdded {
                beforeFrame = afterState!.frame
                afterFrame = afterState!.frame
                beforeOpacity = 0
                afterOpacity = afterState!.opacity
            } else if isRemoved {
                beforeFrame = beforeState!.frame
                afterFrame = beforeState!.frame
                beforeOpacity = beforeState!.opacity
                afterOpacity = 0
            } else {
                beforeFrame = beforeState?.frame ?? afterState!.frame
                afterFrame = afterState?.frame ?? beforeState!.frame
                beforeOpacity = beforeState?.opacity ?? afterState!.opacity
                afterOpacity = afterState?.opacity ?? beforeState!.opacity
            }
            
            var animations: [CAAnimation] = []
            
            if beforeFrame.center != afterFrame.center {
                animations += basicAnimation(keyPath: #keyPath(CALayer.position), from: beforeFrame.center, to: afterFrame.center)
            }
            
            if beforeFrame.size != afterFrame.size {
                animations += basicAnimation(keyPath: #keyPath(CALayer.bounds), from: CGRect(origin: .zero, size: beforeFrame.size), to: CGRect(origin: .zero, size: afterFrame.size))
            }
            
            if beforeState?.backgroundColor != afterState?.backgroundColor {
                animations += basicAnimation(keyPath: #keyPath(CALayer.backgroundColor), from: beforeState?.backgroundColor, to: afterState?.backgroundColor)
            }
            
            if beforeOpacity != afterOpacity {
                animations += basicAnimation(keyPath: #keyPath(CALayer.opacity), from: beforeOpacity, to: afterOpacity)
            }
            
            if beforeState?.shadowPath != afterState?.shadowPath {
                animations += basicAnimation(keyPath: #keyPath(CALayer.shadowPath), from: beforeState?.shadowPath, to: afterState?.shadowPath)
            }
            
            if beforeState?.shadowColor != afterState?.shadowColor {
                animations += basicAnimation(keyPath: #keyPath(CALayer.shadowColor), from: beforeState?.shadowColor, to: afterState?.shadowColor)
            }
            
            if beforeState?.shadowOpacity != afterState?.shadowOpacity {
                animations += basicAnimation(keyPath: #keyPath(CALayer.shadowOpacity), from: beforeState?.shadowOpacity, to: afterState?.shadowOpacity)
            }
            
            if beforeState?.shadowOffset != afterState?.shadowOffset {
                animations += basicAnimation(keyPath: #keyPath(CALayer.shadowOffset), from: beforeState?.shadowOffset, to: afterState?.shadowOffset)
            }
            
            if beforeState?.shadowRadius != afterState?.shadowRadius {
                animations += basicAnimation(keyPath: #keyPath(CALayer.shadowRadius), from: beforeState?.shadowRadius, to: afterState?.shadowRadius)
            }
            
            if layer is CAShapeLayer {

                if beforeState?.path != afterState?.path {
                    animations += basicAnimation(keyPath: #keyPath(CAShapeLayer.path), from: beforeState?.path, to: afterState?.path)
                }

                if beforeState?.fillColor != afterState?.fillColor {
                    animations += basicAnimation(keyPath: #keyPath(CAShapeLayer.fillColor), from: beforeState?.fillColor, to: afterState?.fillColor)
                }

            }
            
            if animations.isNotEmpty {
                let animationGroup = CAAnimationGroup()
                animationGroup.animations = animations
                animationGroup.duration = duration
                animationGroup.fillMode = CAMediaTimingFillMode.forwards
                animationGroup.isRemovedOnCompletion = false
                animationGroup.completionBlock = { _, _ in
    //                view.isHidden = afterState?.isHidden ?? false
    //                if afterState == nil {
    //                    layer.removeFromSuperlayer()
    //                }
                    layer.removeAllAnimations()
                }
                layer.add(animationGroup, forKey: "delayedTransition")
            }
            
        }
        
        CATransaction.commit()
    }
    
    private func basicAnimation(keyPath: String?, from: Any?, to: Any?) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.timingFunction = .default
        return animation
    }
    
    func recordState() -> [CALayer : LayerState] {
        return layer.descendantLayers.associate { layer in
            
            var state: LayerState = [
                "superlayer": layer.superlayer,
                "frame": layer.frame,
                #keyPath(CALayer.zPosition): layer.zPosition,
                #keyPath(CALayer.anchorPointZ): layer.anchorPointZ,
                #keyPath(CALayer.anchorPoint): layer.anchorPoint,
                #keyPath(CALayer.transform): layer.transform,
                #keyPath(CALayer.sublayerTransform): layer.sublayerTransform,
                #keyPath(CALayer.backgroundColor): layer.backgroundColor,
                #keyPath(CALayer.opacity): layer.opacity,
                #keyPath(CALayer.isHidden): layer.isHidden,
                #keyPath(CALayer.shadowPath): layer.shadowPath,
                #keyPath(CALayer.shadowColor): layer.shadowColor,
                #keyPath(CALayer.shadowOpacity): layer.shadowOpacity,
                #keyPath(CALayer.shadowOffset): layer.shadowOffset,
                #keyPath(CALayer.shadowRadius): layer.shadowRadius,
                ]
            
            if let shapeLayer = layer as? CAShapeLayer {
                state += [
                    #keyPath(CAShapeLayer.path): shapeLayer.path,
                    #keyPath(CAShapeLayer.fillColor): shapeLayer.fillColor,
                    #keyPath(CAShapeLayer.strokeColor): shapeLayer.strokeColor,
                    #keyPath(CAShapeLayer.strokeStart): shapeLayer.strokeStart,
                    #keyPath(CAShapeLayer.strokeEnd): shapeLayer.strokeEnd,
                    #keyPath(CAShapeLayer.lineWidth): shapeLayer.lineWidth,
                    #keyPath(CAShapeLayer.miterLimit): shapeLayer.miterLimit,
                    #keyPath(CAShapeLayer.lineDashPhase): shapeLayer.lineDashPhase
                ]
            }
            
            return (layer, state)
        }
    }
    
}

extension CAMediaTimingFunction {
    
    static let `default` = CAMediaTimingFunction(name: .default)
    
}
