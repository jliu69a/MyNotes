//
//  ChangeDateViewController.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/18/21.
//

import UIKit


protocol ChangeDateViewControllerDelegate: AnyObject {
    func didSelectDate(selectedDate: Date)
}

//MARK: -

class ChangeDateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: ChangeDateViewControllerDelegate?
    
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.datePicker.date = self.selectedDate
        
        let frame = self.selectButton.frame
        self.selectButton.layer.cornerRadius = frame.size.height / 4.0
        self.selectButton.clipsToBounds = true
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        self.delegate?.didSelectDate(selectedDate: self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
