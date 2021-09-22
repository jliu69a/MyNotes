//
//  HomeViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var changeTypeItem: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = HomeViewModel()
    
    var rowsList: [String] = []
    var isListingAll = false
    var isFirstTime = true
    var todayDateInText = ""
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.todayDateInText = MyNotesDataManager.sharedInstance.todayDate()
        
        viewModel.delegate = self
        viewModel.allNotes()
        
        self.tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellId")
        
        self.activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNoteTypes), name: Notification.Name("SaveChangesForNoteTypes"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTapped))
        
        self.todayLabel.text = MyNotesDataManager.sharedInstance.currentDisplayDate()
        
        self.tableView.layer.borderColor = UIColor.systemGray2.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isFirstTime {
            self.changeListingAction("" as Any)
            self.isFirstTime = false
        }
    }
    
    @objc func addNewTapped() {
        self.showDetails(item: nil)
    }
    
    @objc func refreshNoteTypes() {
        viewModel.allNotes()
    }
    
    //MARK: -
    
    func changeListingsDisplay(section: Int, isExpanded: Bool) {
        viewModel.changeExpandFlag(sectionIndex: section)
        tableView.reloadData()
    }
    
    //MARK: -
    
    @IBAction func changeListingAction(_ sender: Any) {
        
        self.isListingAll = !self.isListingAll
        self.changeTypeItem.title = self.isListingAll ? "Groups" : "Listings"
        
        viewModel.isListingAll = self.isListingAll
        self.tableView.reloadData()
    }
    
    func showDetails(item: Notes?) {
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
            vc.delegate = self
            vc.selectedNote = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: -
    
    @IBAction func adminPagesAction(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction( UIAlertAction(title: "Edit Types", style: .default, handler: { (action: UIAlertAction) in
            self.showTypesAdminPage()
        }) )
        
        alert.addAction( UIAlertAction(title: "Cancel", style: .destructive, handler: nil) )

        self.present(alert, animated: true, completion: nil)
    }
    
    func showTypesAdminPage() {
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "TypesAdminViewController") as? TypesAdminViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showSortingPage() {
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "SearchNotesViewController") as? SearchNotesViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: -

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.totalSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalRowsInSection(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellId") as? HomeCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.itemWithIndexPath(index: indexPath)
        cell.displayData(item: item, isListingAll: isListingAll, today: self.todayDateInText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForSectionHeater(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = viewModel.titleForSection(index: section)
        let headerView = viewModel.headerView(frame: tableView.frame, section: section, title: title, parentVC: self)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.itemWithIndexPath(index: indexPath)
        self.showDetails(item: item)
    }
}

//MARK: -

extension HomeViewController: HomeViewModelDelegate {
    
    func didHaveAllNotesData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK: -

extension HomeViewController: DetailsViewControllerDelegate {
    
    func didSaveNotesData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
