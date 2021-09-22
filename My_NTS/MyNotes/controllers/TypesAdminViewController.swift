//
//  TypesAdminViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/30/21.
//

import UIKit

class TypesAdminViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewButton: UIButton!
    
    let viewModel = TypesAdminViewModel()
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.title = "Types"
        viewModel.delegate = self
        viewModel.totalCounts()
        viewModel.allTypes()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveNoteTypeChanges), name: Notification.Name("SaveChangesForNoteTypes"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let radius = self.addNewButton.frame.size.height / 4.0
        self.addNewButton.layer.cornerRadius = radius
        self.addNewButton.clipsToBounds = true
    }
    
    @IBAction func addNewTypes(_ sender: Any) {
        self.addEditTypes(item: nil)
    }
    
    func addEditTypes(item: NoteTypes?) {
        let pageTitle = (item == nil) ? "Add" : "Edit"
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "AddEditTypeViewController") as? AddEditTypeViewController {
            vc.pageTitle = pageTitle
            vc.item = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func saveNoteTypeChanges() {
        tableView.reloadData()
    }
}

//MARK: -

extension TypesAdminViewController: TypesAdminViewModelDelegate {
    
    func didHaveAllTypesData() {
        self.tableView.reloadData()
    }
    
    func didHaveTotalCounts() {
        //
    }
}

//MARK: -

extension TypesAdminViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.totalSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalRowsInSection(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId")
        
        let item = viewModel.itemWithIndexPath(index: indexPath)
        let total = viewModel.totalForType(typeId: item.id ?? "0")
        cell?.textLabel?.text = "\(item.name ?? ""), total = \(total)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.itemWithIndexPath(index: indexPath)
        self.addEditTypes(item: item)
    }
}
