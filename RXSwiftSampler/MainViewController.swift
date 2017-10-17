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
        RxProject(name: "Login Validator", desc: "Working with Variable"),
        RxProject(name: "File Reader", desc: "yury"),
        RxProject(name: "Serg Dort", desc: "sergdort"),
        RxProject(name: "Mo Ramezanpoor", desc: "mohsenr"),
        RxProject(name: "Carlos García", desc: "carlosypunto"),
        RxProject(name: "Scott Gardner", desc: "scotteg"),
        RxProject(name: "Nobuo Saito", desc: "tarunon"),
        RxProject(name: "Junior B.", desc: "bontoJR"),
        RxProject(name: "Jesse Farless", desc: "solidcell"),
        RxProject(name: "Jamie Pinkham", desc: "jamiepinkham")
        ])
    
    let disposeBag = DisposeBag()
    
    // Note: You don't need UITableViewDelegate nor UITableViewDataSource methods with RX.
    //       No more cell dequeing!  ...no need to regenerating the tableview cell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { (_, RxProject, cell) in
                // Configure each cell (without the dequeuing):
                cell.textLabel?.text = RxProject.name
                cell.detailTextLabel?.text = RxProject.desc
            }
            .disposed(by: disposeBag)
        
        // This replaces the select @ row delegate method:
        tableView.rx.modelSelected(RxProject.self)
            .subscribe(onNext: {
                print("You selected:", $0)
            })
            .disposed(by: disposeBag)
    }

}
