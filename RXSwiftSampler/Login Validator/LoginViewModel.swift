//  LoginViewModel.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import RxSwift

struct LoginViewModel {
    var emailText = Variable("")
    var passwordText = Variable("")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) {email, password in
            return email.count >= 3 && password.count >= 3
        }
    }
}
