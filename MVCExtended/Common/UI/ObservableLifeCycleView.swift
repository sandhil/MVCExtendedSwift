import Foundation

protocol ObservableLifecycleView: AnyObject {
    
    var lifecycleObservers: [ViewLifecycleObserver] { get set }
    
    func addLifecycleObserver(observer: ViewLifecycleObserver)
    func removeLifecycleObserver(observer: ViewLifecycleObserver)
    
    func notifyViewDidLoad()
    func notifyViewWillAppear()
    func notifyViewDidAppear()
    func notifyViewWillDisappear()
    func notifyViewDidDisappear()
    func notifyViewDidUnload()
    
}

extension ObservableLifecycleView {
    
    func addLifecycleObserver(observer: ViewLifecycleObserver) {
        if (!lifecycleObservers.contains { $0 === observer }) {
            lifecycleObservers += [observer]
        }
    }
    
    func removeLifecycleObserver(observer: ViewLifecycleObserver) {
        lifecycleObservers = lifecycleObservers.filter { $0 !== observer }
    }
    
    func notifyViewDidLoad() {
        lifecycleObservers.forEach { $0.viewDidLoad()}
    }
    
    func notifyViewWillAppear() {
        lifecycleObservers.forEach { $0.viewWillAppear() }
    }
    
    func notifyViewDidAppear() {
        lifecycleObservers.forEach { $0.viewDidAppear() }
    }
    
    func notifyViewWillDisappear() {
        lifecycleObservers.forEach { $0.viewWillDisappear() }
    }
    
    func notifyViewDidDisappear() {
        lifecycleObservers.forEach { $0.viewDidDisappear() }
    }
    
    func notifyViewDidUnload() {
        lifecycleObservers.forEach { $0.viewDidUnload() }
    }
    
}
