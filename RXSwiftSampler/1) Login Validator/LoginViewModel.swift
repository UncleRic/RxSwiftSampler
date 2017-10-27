//  LoginViewModel.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import RxSwift

struct LoginViewModel {
    var emailText = PublishSubject<String>()
    var passwordText = BehaviorSubject(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) {email, password in
            return email.count >= 3 && password.count >= 3
        }
    }
}
