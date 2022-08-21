import UIKit

class MainViewImpl: BaseViewController, MainView {
   
    var dataSource: MainViewDataSource!
    var delegate: MainViewDelegate!
    
    private var isLoggedIn: Bool {
        dataSource.isLoggedIn(for: self)
    }
    
    override func viewDidLoad() {
        
    }
    
    override func updateUI() {
        
    }
    
}
