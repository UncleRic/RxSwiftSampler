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
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var readwriteToggle: UISwitch!
    
    var IOButton = Variable(false)
    let theFile = "TextStuff.txt"
    var fileURL: URL?
    
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    // -----------------------------------------------------------------------------------------------------
    // UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        fileURL = dir.appendingPathComponent(theFile)
        
        let onOffSwitch = Variable(true)
        
        onOffSwitch.asObservable()
            .subscribe (onNext: { [unowned self] isWrite in
                self.writeButton.isHidden = !isWrite
                self.textView.isEditable = isWrite
                if isWrite {
                    self.writeButton.setTitle("Write to Disk", for: .normal)
                    self.pageTitle.text = "Write Stored Disk"
                    self.textView.backgroundColor = UIColor.white
                    self.textView.text = ""
                } else {
                    self.pageTitle.text = "Read Stored Disk"
                    self.textView.backgroundColor = UIColor.clear
                    self.readFromDisk()
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
    
    private func contentsOfTextFile() -> Single<String> {
        if let contents = try? String(contentsOf: fileURL!, encoding: .utf8) {
            return Single.just(contents)
        }
        return Single.just("Sorry... unable to access file.")
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    private func readFromDisk() {
        contentsOfTextFile()
            .subscribe {
                switch $0 {
                case .success(let string):
                    self.textView.textColor = .black
                    self.textView.text = string
                case .error(let error):
                    self.textView.text = error.localizedDescription
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // -----------------------------------------------------------------------------------------------------
    // Action Methods
    
    @IBAction func writeAction() {
        guard let fileURL = fileURL else {
            return
        }
        if let text = textView.text {
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print("error: \(error.localizedDescription)")
                return
            }
        }
        textView.text = "...file has been written."
        textView.textColor = .gray
    }
}
