//
//  DetailsViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/10/21.
//

import UIKit


protocol DetailsViewControllerDelegate: class {
    func didSaveNotesData()
}


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeValueButton: UIButton!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var textViewBottomSpace: NSLayoutConstraint!
    
    weak var delegate: DetailsViewControllerDelegate?
    
    let originalTextViewBottomSpace: CGFloat = 60
    var selectedNote: Notes? = nil
    var selectedNoteTypeId: String = "0"
    
    let displayFormat = MyNotesDataManager.sharedInstance.displayFormat
    var selectedDate = Date()
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if let note = selectedNote {
            self.selectedDate = MyNotesDataManager.sharedInstance.textToDate(dateText: (note.date_time ?? ""))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.contentTextView.layer.borderColor = UIColor.systemGray2.cgColor
        self.contentTextView.layer.borderWidth = 0.5
        
        let typeRadius = self.typeValueButton.frame.size.height / 4.0
        self.typeValueButton.layer.cornerRadius = typeRadius
        self.typeValueButton.clipsToBounds = true
        
        self.showData()
        
        //-- for desc text view
        let screenWidth = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Close", style: .plain, target: target, action: #selector(close))
        toolBar.setItems([flexible, barButton], animated: false)
        self.contentTextView.inputAccessoryView = toolBar
    }
    
    func showData() {
        
        guard let validSelectedNote = self.selectedNote else {
            let dateString = MyNotesDataManager.sharedInstance.displayDateWithFormat(format: self.displayFormat, date: self.selectedDate)
            self.dateValueLabel.text = "Date:  \(dateString)"
            
            self.typeValueButton.setTitle("Change Type", for: .normal)
            self.typeValueButton.setTitle("Change Type", for: .highlighted)
            
            return
        }
        
        let oldFormat = MyNotesDataManager.sharedInstance.itemFormat
        let newFormat = MyNotesDataManager.sharedInstance.displayFormat
        let displayDate = MyNotesDataManager.sharedInstance.formatDisplayDate(dateText: (validSelectedNote.date_time ?? ""), oldFormat: oldFormat, newFormat: newFormat)
        
        self.titleTextField.text = validSelectedNote.title ?? ""
        self.dateValueLabel.text = "Date:  \(displayDate)"
        self.contentTextView.text = validSelectedNote.content ?? ""
        
        self.selectedNoteTypeId = validSelectedNote.type_id ?? "0"
        let typeName = MyNotesDataManager.sharedInstance.typeNameWithId(id: validSelectedNote.type_id ?? "0")
        let displayType = "Type: \(typeName)"
        
        self.typeValueButton.setTitle(displayType, for: .normal)
        self.typeValueButton.setTitle(displayType, for: .highlighted)
    }
    
    func dismissKeyboard() {
        self.titleTextField.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
    }
    
    @objc func close() {
        self.contentTextView.resignFirstResponder()
    }
    
    @IBAction func changeTypeAction(_ sender: Any) {
        self.dismissKeyboard()
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "TypesViewController") as? TypesViewController {
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func dateButtonTapped() {
        self.dismissKeyboard()
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ChangeDateViewController") as? ChangeDateViewController {
            vc.delegate = self
            vc.selectedDate = self.selectedDate
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.textViewBottomSpace.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.textViewBottomSpace.constant = self.originalTextViewBottomSpace
    }
}

//MARK: -

extension DetailsViewController {
    
    func goback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.goback()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        //-- insert OR update
        
        if self.selectedNoteTypeId == "0" {
            self.showAlert(title: "Must select a note type.", message: nil)
            return
        }
        
        let actionCode = (self.selectedNote == nil) ? DatasManager.sharedInstance.kInsertCode : DatasManager.sharedInstance.kUpdateCode
        let validSelectedNote = self.selectedNote ?? Notes()
        self.savingNotes(notes: validSelectedNote, actionCode: actionCode)
    }
    
    func savingNotes(notes: Notes, actionCode: Int) {
        var validNotes = notes
        
        validNotes.title = self.titleTextField.text ?? ""
        validNotes.content = self.contentTextView.text
        validNotes.type_id = self.selectedNoteTypeId
        
        let itemFormat = MyNotesDataManager.sharedInstance.itemFormat
        validNotes.date_time = MyNotesDataManager.sharedInstance.displayDateWithFormat(format: itemFormat, date: self.selectedDate)
        
        MyNotesDataManager.sharedInstance.changeNotesWithData(code: actionCode, item: validNotes) { (any: Any) in
            self.delegate?.didSaveNotesData()
            self.goback()
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        //-- delete
        
        if self.selectedNote == nil {
            self.showAlert(title: "The selected note is nil.", message: nil)
            return
        }
        self.confirmAlert(title: "Do you want to delete this note?", message: nil)
    }
    
    func deleteSelectedNote() {
        
        if let validNotes = self.selectedNote {
            let actionCode = DatasManager.sharedInstance.kDeleteCode
            MyNotesDataManager.sharedInstance.changeNotesWithData(code: actionCode, item: validNotes) { (any: Any) in
                self.delegate?.didSaveNotesData()
                self.goback()
            }
        }
    }
    
    func showAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil) )
        
        alert.addAction( UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            self.deleteSelectedNote()
        }) )
        
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: -

extension DetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

//MARK: -

extension DetailsViewController: TypesViewControllerDelegate {
    
    func didSelectItem(item: NoteTypes) {
        self.selectedNoteTypeId = item.id ?? "0"
        
        let displayType = "Type: \(item.name ?? "")"
        self.typeValueButton.setTitle(displayType, for: .normal)
        self.typeValueButton.setTitle(displayType, for: .highlighted)
    }
}

//MARK: -

extension DetailsViewController: ChangeDateViewControllerDelegate {
    
    func didSelectDate(selectedDate: Date) {
        self.selectedDate = selectedDate
        
        let dateString = MyNotesDataManager.sharedInstance.displayDateWithFormat(format: self.displayFormat, date: self.selectedDate)
        self.dateValueLabel.text = "Date:  \(dateString)"
    }
}
