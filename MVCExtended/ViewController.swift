//
//  ViewController.swift
//  CocoaPet
//
//  Created by Sandhil on 28/07/2022.
//

import UIKit
import CoreData
import RxSwift
import RxAlamofire

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ =  fetchCommits()
            .subscribe(onSuccess: {user in
                print("user", user.count)
            }, onFailure: {error in
                
            }).disposed(by: disposeBag)
        
        
    }
    
    func fetchCommits() -> Single<[User]>{
        
        let apiClient = APIClient()
        
        return apiClient.load(expecting: User.self, request: ApiRequest(method: .get, url: "https://jsonplaceholder.typicode.com/posts"))
            .observe(on: Schedulers.computation)
    }
}


class Users: Codable {
    
    var users: User?
}


class User: Codable {
    
    let userId: Int?
    let title: String?
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    
    func doOnSuccess(_ onSuccess: @escaping (Element) -> Void) -> PrimitiveSequence<SingleTrait, Self.Element> {
        return self.do(onSuccess: onSuccess, onError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    }
    
}
