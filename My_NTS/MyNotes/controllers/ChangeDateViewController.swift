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
    @IBOutlet weak var currentDateButton: UIButton!
    
    weak var delegate: ChangeDateViewControllerDelegate?
    
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.datePicker.date = self.selectedDate
        
        let frame1 = self.selectButton.frame
        self.selectButton.layer.cornerRadius = frame1.size.height / 4.0
        self.selectButton.clipsToBounds = true
        
        let frame2 = self.currentDateButton.frame
        self.currentDateButton.layer.cornerRadius = frame2.size.height / 4.0
        self.currentDateButton.clipsToBounds = true
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        chooseDate(date: self.datePicker.date)
    }
    
    @IBAction func currentDateAction(_ sender: Any) {
        chooseDate(date: Date())
    }
    
    private func chooseDate(date: Date) {
        self.delegate?.didSelectDate(selectedDate: date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
