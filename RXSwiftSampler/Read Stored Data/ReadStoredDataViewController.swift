//  ReadStoredDataViewController.swift
//  RXSwiftSampler
//
//  This code uses the Single Deferred method.
//
//  Created by Frederick C. Lee on 10/18/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit
import RxCocoa
import RxSwift

class ReadStoredDataViewController: UIViewController {
    
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var readwriteButton: UIButton!
    @IBOutlet weak var readwriteToggle: UISwitch!
    
    var IOButton = Variable(false)
    
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    // -----------------------------------------------------------------------------------------------------
    // UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onOffSwitch = Variable(true)
        
        onOffSwitch.asObservable()
            .subscribe (onNext: { [unowned self] isWrite in
                if isWrite {
                    self.readwriteButton.setTitle("Write to Disk", for: .normal)
                    self.pageTitle.text = "Write Stored Disk"
                } else {
                    self.readwriteButton.setTitle("Read from Disk", for: .normal)
                    self.pageTitle.text = "Read Stored Disk"
                }
            }).disposed(by: disposeBag)
        
        readwriteToggle.rx.isOn.bind(to: onOffSwitch)
            .disposed(by: disposeBag)
        
        swipeGestureRecognizer.rx.event
            .bind { [unowned self] _ in
                print("Swipe Gesture")
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    private func contentsOfTextFile(named name: String) -> Single<String> {
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
            print(FileReadError.fileNotFound)
            return Single.just("File Not Found")
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            return Single.just("File Unreadable")
        }
        
        guard let contents = String(data:data, encoding:.utf8) else {
            return Single.just("File Encoding Failed")
        }
        
        return Single.just(contents)
    }
    
    // -----------------------------------------------------------------------------------------------------
    // Action Methods
    
    @IBAction func readwriteAction() {
        contentsOfTextFile(named: "Jonathan")
            .subscribe {
                switch $0 {
                case .success(let string):
                    self.textView.text = string
                case .error(let error):
                    self.textView.text = error.localizedDescription
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
