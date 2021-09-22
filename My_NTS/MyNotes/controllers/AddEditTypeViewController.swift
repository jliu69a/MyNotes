//
//  AddEditTypeViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 6/11/21.
//

import UIKit


class AddEditTypeViewController: UIViewController {
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveBottomSpace: NSLayoutConstraint!
    
    let viewModel = TypesEditViewModel()
    let originalSaveBottomSpace: CGFloat = 20
    
    var item: NoteTypes? = nil
    var pageTitle: String = ""
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pageTitle
        
        viewModel.delegate = self
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let radius = self.saveButton.frame.size.height / 4.0
        self.saveButton.layer.cornerRadius = radius
        self.saveButton.clipsToBounds = true
        
        typeTextField.text = item?.name ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        typeTextField.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        typeTextField.resignFirstResponder()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        dismissKeyboard()
        if typeTextField.text == nil || typeTextField.text?.count == 0 {
            noDataAlert()
            return
        }
        
        let isNewType = (item == nil)
        var newType = item ?? NoteTypes()
        newType.name = typeTextField.text ?? ""
        viewModel.changeType(isNew: isNewType, item: newType)
    }
    
    func noDataAlert() {
        
        let alert = UIAlertController(title: "The type name cannot be empty.", message: nil, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.saveBottomSpace.constant = keyboardSize.height + originalSaveBottomSpace
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.saveBottomSpace.constant = originalSaveBottomSpace
    }
}


extension AddEditTypeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}


//MARK: -

extension AddEditTypeViewController: TypesEditViewModelDelegate {
    
    func didSaveChanges() {
        NotificationCenter.default.post(name: Notification.Name("SaveChangesForNoteTypes"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
