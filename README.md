# Swift-MVC
Ready to use template for iOS Swift

## Getting started

Swift-MVC uses an event driven approach to decouple the business logic from UIVIewController. One of the major drawbacks of the MVC design pattern in iOS is controller logic is tightly coupled with view. Hence it is hard to write unit tests. 

We eliminate this by decoupling the business logic from UIViewController to a custom Controller class, which is a component in our design pattern which takes care of all the business logic. The UIVIewcontroller(ViewImpl we call it) deals only with the view manipulations. ViewImpl has two dataSource and delegate to receive and send data to the Controller. 

Major components of the design patterns are:- 

1. Controller

> Controller does all the business logic to get or set data from the remote or local repositories. It conforms to two protocols data source and delegate which is used to communicate between the controller and the **ViewImpl(UIViewController)**. It also observes the view life cycle through a protocol called **ObservableLifecycleView**. That means we will call backs like **viewDidLoad, viewWillAppear** etc in our controller class. 

```swift
import Foundation

class MainController: ViewLifecycleObserver, MainViewDataSource, MainViewDelegate {
    
    weak var view: MainView!
    let backendClient: BackendClient
    let sessionManager: SessionManager
    
    init(view: MainView, backendClient: BackendClient, sessionManager: SessionManager) {
        self.view = view
        self.backendClient = backendClient
        self.sessionManager = sessionManager
        self.view.dataSource = self
        self.view.delegate = self
        
        //Observe to the view life cycle events.
        observe(view)
        
    }
    // UIViewContoller viewDidLoad
    func viewDidLoad() {
        
    }
    
    //Delegate method declared in MainViewDelegate
    func isLoggedIn(for: MainView) -> Bool {
        sessionManager.isLoggedIn
    }
    
    //Delegate method declared in MainViewDelegate
    func didSubmit(in: MainView) {
    }
}
```

2. View

> Every view has two variables which will be a data source and delegate. Both data source and delegates are protocols which declare methods to give data to the ViewImpl and get data or notify the controller according to events. It also has an important method called notifyDataChanged. We can call this method to update the view. You can override **updateUI** method in the **ViewImpl** class and whenever we call **notifyDataChanged** from the controller **updateUI** will be invoked.

```swift
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
    func didSubmit(in: MainView)
}
```

3. ViewImpl(ViewController)

> This is the actual **UIVIewController** where we update the contents of the views or responds to users interactions.

4. MVCCoordinator 

> This is the class we used to set up all the initialization. We initialise all the events in this class. We instantiate our controller class inside the **viewDidInit** method based on the type of the view. It also acts as a **Dependency Injector** class. We can inject the dependencies through the constructor of the controller. MVCCoordinator is initialised in the AppDelegate class.

```swift

@objc func viewDidInit(notification: Notification) throws {
        
        let view = notification.object as! MVCView
        let controller: Any?
        
        switch view {
        case is MainView:
            controller = MainController(view: view as! MainView, backendClient: backendClient)
        default:
            controller = nil
            
        }
        
        if controller != nil {
            viewControllerPairs += ViewControllerPair(
                view: view,
                controller: controller
            )
        }
 }
    
```

```
MIT License

Copyright (c) 2022 Sandhil Eldhose

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 ```
