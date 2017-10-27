//  MainViewController.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let data = Observable.of([
        RxProject(topic: .one, name: "Login Validator", chapter: "Variable"),
        RxProject(topic: .two, name: "File I/O", chapter: "Variable, Bind, Single"),
        RxProject(topic: .three, name: "Serg Dort", chapter: "Collection"),
        RxProject(name: "Mo Ramezanpoor", chapter: "mohsenr"),
        RxProject(name: "Carlos García", chapter: "carlosypunto"),
        RxProject(name: "Scott Gardner", chapter: "scotteg"),
        RxProject(name: "Nobuo Saito", chapter: "tarunon"),
        RxProject(name: "Junior B.", chapter: "bontoJR"),
        RxProject(name: "Jesse Farless", chapter: "solidcell"),
        RxProject(name: "Jamie Pinkham", chapter: "jamiepinkham")
        ])
    
    let disposeBag = DisposeBag()
    
    // Note: You don't need UITableViewDelegate nor UITableViewDataSource methods with RX.
    //       No more cell dequeing!  ...no need to regenerating the tableview cell!
    // -----------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { (_, rxProject, cell) in
                // Configure each cell (without the dequeuing):
                cell.textLabel?.text = rxProject.name
                cell.detailTextLabel?.text = rxProject.chapter
            }
            .disposed(by: disposeBag)
        
        // This replaces the select @ row delegate method:
        tableView.rx.modelSelected(RxProject.self)
            .subscribe(onNext: {
                print("You selected:", $0)
                
                switch $0.topic {
                case .one:
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                        self.present(vc, animated: true, completion: nil)
                    }
                case .two:
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReadStoredDataVC") {
                        self.present(vc, animated: true, completion: nil)
                    }
                case .three:
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollectionVC") {
                        self.present(vc, animated: true, completion: nil)
                    }
                default:
                    print("default")
                }
            })
            .disposed(by: disposeBag)
        
    }
}
