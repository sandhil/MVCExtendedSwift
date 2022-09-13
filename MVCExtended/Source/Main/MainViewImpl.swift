import UIKit

class MainViewImpl: BaseViewController, MainView {
   
    
    var dataSource: MainViewDataSource!
    
    var delegate: MainViewDelegate!
    
    
    private var isLoggedIn: Bool {
        dataSource.isLoggedIn(for: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateUI() {
        delegate.didSubmit(in: self)
    }
    
}
