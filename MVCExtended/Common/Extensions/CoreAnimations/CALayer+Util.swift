import QuartzCore

extension CALayer {
    
    var ancestorLayers: [CALayer] {
        if superlayer == nil {
            return []
        } else {
            return [superlayer!] + superlayer!.ancestorLayers
        }
    }
    
    var descendantLayers: [CALayer] {
        
        var children = sublayers ?? []
        
        if mask != nil {
            children += mask!
        }
        
        return children + children.flatMap { $0.descendantLayers }
    }
    
}
