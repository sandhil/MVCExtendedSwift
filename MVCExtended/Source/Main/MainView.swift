import Foundation

protocol MainView: ObservableLifecycleView {
    
    var dataSource: MainViewDataSource! { get set }
    var delegate: MainViewDelegate!  { get set }
    
    func notifyDataChanged()
}

protocol MainViewDataSource: AnyObject {
    func isLoggedIn(for: MainView) -> Bool
}

protocol MainViewDelegate: AnyObject {
    
    
}
