import UIKit


typealias ControllerPreparationHandler = (Any) -> Void

enum RegisterControllerPreparationHandlerParameters {
    case view
    case preparationHandler
}

struct ControllerSegue {
    let destinationViewController: UIViewController
    let preparationHandler: ControllerPreparationHandler?
}

class MVCCoordinator {
    
    let window: UIWindow
    
    private var viewControllerPairs: [ViewControllerPair] = []
    private let backendClient: BackendClient
    
    init(window: UIWindow) {
        
        self.window = window
        
        let baseURL = Constants.baseURL
        let apiClient = APIClient(baseURL: baseURL)
        backendClient = BackendClient(myRiwalApi: apiClient)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidInit(notification:)), name: .viewDidInit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidDeinit(notification:)), name: .viewDidDeinit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareControllerForBaseView(notification:)), name: .registerControllerPreparationHandler, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareControllerForBaseViewController(notification:)), name: .prepareForSegue, object: nil)
        
    }
    
    func showFirstScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        //        if isLoggedIn {
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            window.rootViewController = storyboard.instantiateInitialViewController()
        //        } else {
        //            let storyboard = UIStoryboard(name: "WelcomeView", bundle: nil)
        //            window.rootViewController = storyboard.instantiateInitialViewController()
        //        }
        
    }
    
    @objc func viewDidInit(notification: Notification) throws {
        
        let view = notification.object as! MVCView
        let controller: Any?
        
        switch view {
        case is MainView:
            controller = MainController(view: view as! MainView, backendClient: backendClient)
        default:
            controller = nil
            
        }
        
        if controller != nil {
            viewControllerPairs += ViewControllerPair(
                view: view,
                controller: controller
            )
        }
    }
    
    @objc func viewDidDeinit(notification: Notification) throws {
        let view = notification.object as! MVCView
        viewControllerPairs = viewControllerPairs.filter { $0.view != nil && $0.view! !== view }
    }
    
    @objc func prepareControllerForBaseView(notification: Notification) {
        
        let params = notification.userInfo!
        let view = params[RegisterControllerPreparationHandlerParameters.view] as! BaseView
        let preparationHandler = params[RegisterControllerPreparationHandlerParameters.preparationHandler] as! ControllerPreparationHandler
        
        prepareControllerForView(view, preparationHandler: preparationHandler)
    }
    
    @objc func prepareControllerForBaseViewController(notification: Notification) {
        
        let controllerSegue = notification.object as! ControllerSegue
        let viewController = controllerSegue.destinationViewController
        let preparationHandler = controllerSegue.preparationHandler
        
        let firstDescendantViewWithController = viewController.descendantViewControllers.first { view in
            viewControllerPairs.contains { $0.view === view }
        } as? BaseViewController
        
        prepareControllerForView(firstDescendantViewWithController, preparationHandler: preparationHandler)
    }
    
    private func prepareControllerForView(_ view: MVCView?, preparationHandler: ControllerPreparationHandler?) {
        
        let destinationController = viewControllerPairs.first { $0.view === view }?.controller
        
        if destinationController != nil && preparationHandler != nil {
            preparationHandler!(destinationController!)
        }
    }
    
    struct ViewControllerPair {
        weak var view: MVCView?
        var controller: Any?
    }
}
