import UIKit

class BaseView: UIView, MVCView, ObservableLifecycleView {
    
    
    /*---------------------------------------- Properties ----------------------------------------*/
    
    
    var lifecycleObservers: [ViewLifecycleObserver] = []
    
    private var isAppearing = false
    private var isDisappearing = false
    
    private var canAnimate = false
    private var animateLayoutChanges = false
    private var viewLayerStatesBeforeAnimation: [CALayer : LayerState] = [:]
    private var nonAnimatingViews: [UIView] = []
    private var parentsOfNonAnimatingViews: [UIView] = []
    
    
    /*---------------------------------------- Lifecycle -----------------------------------------*/
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.post(name: .viewDidInit, object: self)
        didLoad()
        notifyViewDidLoad()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        NotificationCenter.default.post(name: .viewDidInit, object: self)
        didLoad()
        notifyViewDidLoad()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        
        if window == nil && newWindow != nil {
            willAppear()
            notifyViewWillAppear()
            isAppearing = true
        } else if window != nil && newWindow == nil {
            willDisappear()
            notifyViewWillDisappear()
            isDisappearing = true
        }
    }
    
    override func didMoveToWindow() {
        if isAppearing {
            didAppear()
            notifyViewDidAppear()
            isAppearing = false
        } else if isDisappearing {
            didDisappear()
            notifyViewDidDisappear()
            isDisappearing = false
        }
    }
    
    open func didLoad() {
        
    }
    
    open func willAppear() {
        
    }
    
    open func didAppear() {
        canAnimate = true
    }
    
    open func willDisappear() {
        
    }
    
    open func didDisappear() {
        viewLayerStatesBeforeAnimation = [:]
    }
    
    open func didUnload() {
        
    }
    
    deinit {
        didUnload()
        notifyViewDidUnload()
        NotificationCenter.default.post(name: .viewDidDeinit, object: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
        animateLayoutChangesIfNeeded()
    }
    
    
    /*----------------------------------------- Methods ------------------------------------------*/
    
    
    func beginDelayedTransitions(excluding nonAnimatingViews: [UIView] = [], excludingChildrenOf parentsOfNonAnimatingViews: [UIView] = []) {
        guard canAnimate else { return }
        animateLayoutChanges = true
        viewLayerStatesBeforeAnimation = recordState()
        self.nonAnimatingViews = nonAnimatingViews
        self.parentsOfNonAnimatingViews = parentsOfNonAnimatingViews
    }
    
    func notifyDataChanged() {
        runOnUIThread {
            self.setNeedsUpdateUI()
        }
    }
    
    func setNeedsUpdateUI() {
        setNeedsLayout()
    }
    
    func animateLayoutChangesIfNeeded() {
        guard canAnimate && animateLayoutChanges else { return }
        animateToCurrentLayout(from: viewLayerStatesBeforeAnimation, excluding: nonAnimatingViews, excludingChildrenOf: parentsOfNonAnimatingViews)
        animateLayoutChanges = false
        viewLayerStatesBeforeAnimation = [:]
    }
    
    open func updateUI() {
        
    }
    
    func performSegue(withIdentifier identifier: String, sender: Any?, destinationControllerPreparationHandler: @escaping ControllerPreparationHandler) {
        guard let baseViewController = self.parentViewController as? BaseViewController else { return }
        baseViewController.performSegue(withIdentifier: identifier, sender: sender, destinationControllerPreparationHandler: destinationControllerPreparationHandler)
    }
    
}

extension UIView {
    
    func addSubview(_ view: BaseView, controllerPreparationHandler: @escaping ControllerPreparationHandler) {
        
        let params: [RegisterControllerPreparationHandlerParameters : Any] = [
            .view : view,
            .preparationHandler : controllerPreparationHandler
        ]
        
        NotificationCenter.default.post(name: .registerControllerPreparationHandler, object: self, userInfo: params)
        addSubview(view)
    }
    
}
