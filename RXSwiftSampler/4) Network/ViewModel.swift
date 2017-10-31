//  ViewModel.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/30/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import RxSwift
import RxCocoa

typealias JSONType = [String:Any]
struct Repository {
    let name: String
    let url: String
}

class ViewModel {
    let searchText = Variable("")
    lazy var data: Driver<[Repository]> = {
       return self.searchText.asObservable()
        .throttle(0.3, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest(ViewModel.repositoriesFor)
        .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesFor(_ gitHubID: String) -> Observable<[Repository]> {
        guard !gitHubID.isEmpty,
            let url = URL(string:"https://api.github.com/users/\(gitHubID)/repos")
            else {
                return Observable.just([])
        }
        return URLSession.shared
            .rx.json(url:url)
            .retry(3)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [JSONType] else {return []}
        
        var repositories = [Repository]()
        
        items.forEach {
            guard let name = $0["name"] as? String,
            let url = $0["html_url"] as? String
                else {return}
            repositories.append(Repository(name: name, url: url))
        }
        return repositories
    }
}
