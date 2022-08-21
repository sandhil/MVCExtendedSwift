

import Foundation

class MainController: ViewLifecycleObserver, MainViewDataSource, MainViewDelegate {
    
    
    weak var view: MainView!
    let backendClient: BackendClient
    
    init(view: MainView, backendClient: BackendClient) {
        self.view = view
        self.backendClient = backendClient
        observe(view)
        
    }
    
    func viewDidLoad() {
        
        
    }
    
    func isLoggedIn(for: MainView) -> Bool {
        true
    }
    
}
