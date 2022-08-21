import Foundation

extension Notification.Name {
    
    static let viewDidInit = Notification.Name("viewDidInit")
    static let viewDidDeinit = Notification.Name("viewDidDeinit")
    static let registerControllerPreparationHandler = Notification.Name("registerControllerPreparationHandler")
    static let prepareForSegue = Notification.Name("prepareForSegue")
}
