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
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    let disposeBag = DisposeBag()
    var viewModel = ViewModel()
    
    // -----------------------------------------------------------------------------------------------------
    // UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        swipeGestureRecognizer.rx.event
            .bind { [unowned self] _ in 
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        configureSearchController()
        
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        // ... Toying with Filter.
        viewModel.searchText.asObservable()
            .filter {item in
                item.count > 3
            }
            .subscribe(onNext: { (txtCharacter) in
                print("txtCharacter: \(txtCharacter)")
            }, onCompleted: {
                print("---- Completed! -----")
            })
            .disposed(by:disposeBag)
        
        viewModel.data.asDriver()
            .map { "\($0.count) Repositories" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "scotteg"
        searchBar.placeholder = "Enter Github ID (e.g. \"scotteg\")"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}

// ==========================================================================================================

extension NetworkViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("--- Cancel Action ---")
    }
}
