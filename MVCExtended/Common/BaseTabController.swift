
import UIKit

class BaseTabBarController: UITabBarController, MVCView, ObservableLifecycleView {
    
    
    /*--------------------------------------- Properties -----------------------------------------*/
    
    
    var lifecycleObservers: [ViewLifecycleObserver] = []
    
    private var canAnimate = false
    private var animateLayoutChanges = false
    private var nonAnimatingViews: [UIView] = []
    private var parentsOfNonAnimatingViews: [UIView] = []
    
    
    /*---------------------------------------- Lifecycle -----------------------------------------*/
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.post(name: .viewDidInit, object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifyViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifyViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notifyViewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifyViewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notifyViewDidDisappear()
    }
    
    deinit {
        notifyViewDidUnload()
        NotificationCenter.default.post(name: .viewDidDeinit, object: self)
    }
    
    func notifyDataChanged() {
        runOnUIThread {
            self.setNeedsUpdateUI()
        }
    }
    
    func setNeedsUpdateUI() {
        view.setNeedsLayout()
    }
    
    override func viewWillLayoutSubviews() {
        updateUI()
    }
    
    open func updateUI() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.post(name: .prepareForSegue, object: segue)
    }
    
}
