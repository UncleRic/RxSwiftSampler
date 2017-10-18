//
//  LoginViewController.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecognizer.rx.event
            .bind { [unowned self] _ in
                print("Tap Gesture")
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        _ = emailTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.emailText)
        _ = passwordTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.passwordText)
        _ = loginViewModel.isValid.bind(to: loginButton.rx.isEnabled)
        loginViewModel.isValid.subscribe(onNext: {[unowned self] isValid in
            self.loginLabel.text = isValid ? "Enabled" : "Not Enabled"
            self.loginLabel.textColor = isValid ? .green : .red
        }).disposed(by: disposeBag)
        
    }
}