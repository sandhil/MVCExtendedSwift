import Foundation

extension OperationQueue {
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
}
