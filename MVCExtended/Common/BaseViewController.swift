import UIKit

class BaseViewController: UIViewController, MVCView, ObservableLifecycleView {
    
    
    /*---------------------------------------- Properties ----------------------------------------*/
    
    
    var lifecycleObservers: [ViewLifecycleObserver] = []
    var destinationControllerPreparationHandler: ControllerPreparationHandler?
    
    @IBInspectable var hideNavigationBarOnPush: Bool = false
    
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
        navigationController?.setNavigationBarHidden(hideNavigationBarOnPush, animated: animated)
        notifyViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canAnimate = true
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        notifyViewDidUnload()
        NotificationCenter.default.post(name: .viewDidDeinit, object: self)
    }
    
    
    /*----------------------------------------- Methods ------------------------------------------*/
    
    
    func notifyDataChanged() {
        runOnUIThread {
            self.setNeedsUpdateUI()
        }
    }
    
    func setNeedsUpdateUI() {
        view.setNeedsLayout()
    }
    
    open func updateUI() {
        
    }
    
    func performSegue(withIdentifier identifier: String, sender: Any?, destinationControllerPreparationHandler: @escaping ControllerPreparationHandler) {
        self.destinationControllerPreparationHandler = destinationControllerPreparationHandler
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controllerSegue = ControllerSegue(destinationViewController: segue.destination, preparationHandler: destinationControllerPreparationHandler)
        NotificationCenter.default.post(name: .prepareForSegue, object: controllerSegue)
        destinationControllerPreparationHandler = nil
    }
    
}

extension UIViewController {
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil, destinationControllerPreparationHandler: @escaping ControllerPreparationHandler) {
        present(viewControllerToPresent, animated: flag, completion: completion)
        let controllerSegue = ControllerSegue(destinationViewController: viewControllerToPresent, preparationHandler: destinationControllerPreparationHandler)
        NotificationCenter.default.post(name: .prepareForSegue, object: controllerSegue)
    }
    
}
