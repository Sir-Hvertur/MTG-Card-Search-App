//
//  CustomSearchTextField.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 27/02/2021.
//

import UIKit

class CustomSearchTextField: UITextField {
    
    //Search Results
    var resultsListArray: [String]?
    var tableView: UITableView?
    var searchManager = SearchManager()
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        searchManager.delegate = self
    }
    
    @objc open func textFieldDidChange(){
        if self.text!.count >= 2 {
            searchManager.fetchSearchResults(searchString: self.text ?? "Ebon Praetor")
            tableView?.isHidden = false

        }
        else {
            tableView?.isHidden = true
        }
    }
    
}

//MARK: - SearchTableView Methods
extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {
    
    func buildSearchTableView() {
        
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)
        }
        else {
            print("TableView created.")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            
            if tableView.contentSize.height > 220 {
                tableHeight = 220
            } else {
                tableHeight = tableView.contentSize.height
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.cornerRadius = 5.0
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            tableView.reloadData()
        }
    }
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsListArray?.count ?? 0
    }
    
    // MARK: TableViewDelegate methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CustomSearchTextFieldCell")
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = resultsListArray?[indexPath.row].description
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = resultsListArray?[indexPath.row].description
        tableView.isHidden = true
        self.endEditing(true)
    }
    
}

//MARK: - SearchManagerDelegate
extension CustomSearchTextField: SearchManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateSearchResults(_ searchManager: SearchManager, searchResults: SearchModel) {
        DispatchQueue.main.async {
            self.resultsListArray = searchResults.data!
            print("Results in list updated, there is \(self.resultsListArray?.count ?? -10) items.")
            self.buildSearchTableView()
      
        }
    }
    
}
