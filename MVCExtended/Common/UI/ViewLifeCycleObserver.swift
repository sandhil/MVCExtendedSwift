import Foundation

protocol ViewLifecycleObserver: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    func viewDidUnload()
}

extension ViewLifecycleObserver {
    
    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewDidAppear() { }
    func viewWillDisappear() { }
    func viewDidDisappear() { }
    func viewDidUnload() { }
    
    func observe(_ view: ObservableLifecycleView) {
        view.addLifecycleObserver(observer: self)
    }
    
    func stopObserving(view: ObservableLifecycleView) {
        view.removeLifecycleObserver(observer: self)
    }
    
}
