

import Foundation

class MainController: ViewLifecycleObserver, MainViewDataSource, MainViewDelegate {
    
    
    
    weak var view: MainView!
    let backendClient: BackendClient
    
    init(view: MainView, backendClient: BackendClient) {
        self.view = view
        self.backendClient = backendClient
        self.view.dataSource = self
        self.view.delegate = self
       
        observe(view)
        self.view.dataSource = self
        
    }
    
    func viewDidLoad() {
        
    }
    
    func isLoggedIn(for: MainView) -> Bool {
        self.view.delegate = self
        return true
    }
    
    func didSubmit(in: MainView) {
    }
    
}
