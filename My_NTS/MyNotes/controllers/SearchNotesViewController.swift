//
//  SearchNotesViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 9/20/21.
//

import UIKit

class SearchNotesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
