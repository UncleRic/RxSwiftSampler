//  NetworkViewController.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/30/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit
import RxSwift
import RxCocoa

class NetworkViewController: UIViewController {

    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipeGestureRecognizer.rx.event
            .bind { [unowned self] _ in
                print("Swipe Gesture")
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

}
