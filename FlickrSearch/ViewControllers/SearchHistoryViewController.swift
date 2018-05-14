//
//  SearchHistoryViewController.swift
//  FlickrSearch
//
//  Created by Sanju Naik on 6/15/17.
//  Copyright © 2017 Sanju. All rights reserved.
//

import UIKit

protocol SearchHistoryViewControllerDelegate: class {
    func userDidSelect(searchText: String) -> Void
}

class SearchHistoryViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView?
    weak var delegate: SearchHistoryViewControllerDelegate?
}


extension SearchHistoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0))
        searchTableView?.keyboardDismissMode = .onDrag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadTableView() -> Void {
        searchTableView?.reloadData()
    }

}


extension SearchHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchHistoryManager.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = SearchHistoryManager.history[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userDidSelect(searchText: SearchHistoryManager.history[indexPath.row])
    }
}
