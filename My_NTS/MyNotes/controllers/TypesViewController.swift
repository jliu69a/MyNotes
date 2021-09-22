//
//  TypesViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/14/21.
//

import UIKit


protocol TypesViewControllerDelegate: AnyObject {
    func didSelectItem(item: NoteTypes)
}

//MARK: -

class TypesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: TypesViewControllerDelegate?
    
    var rowsList = MyNotesDataManager.sharedInstance.noteTypesList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TypeCellId")
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNoteTypes), name: Notification.Name("SaveChangesForNoteTypes"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemGray2.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
    
    func showSelectedItem(item: NoteTypes) {
        self.delegate?.didSelectItem(item: item)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshNoteTypes() {
        self.rowsList = MyNotesDataManager.sharedInstance.noteTypesList
        self.tableView.reloadData()
    }
}

//MARK: -

extension TypesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCellId")
        
        let type = self.rowsList[indexPath.row]
        cell?.textLabel?.text = type.name
        cell?.accessoryType = UITableViewCell.AccessoryType.none
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = self.rowsList[indexPath.row]
        self.showSelectedItem(item: type)
    }
}
