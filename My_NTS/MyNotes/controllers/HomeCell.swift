//
//  HomeCell.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/12/21.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var todayIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayData(item: Notes, isListingAll: Bool, today: String) {
        
        self.titleLabel.text = item.title
        
        let type = item.type_name ?? ""
        self.typeLabel.text = "\(type)"
        self.typeLabel.textColor = MyNotesDataManager.sharedInstance.colorForType(type: type)
        self.typeLabel.isHidden = !isListingAll
        
        let dateText = MyNotesDataManager.sharedInstance.changeToDisplay(dateText: (item.date_time ?? ""))
        self.dateLabel.text = dateText
        
        self.todayIndicator.backgroundColor = UIColor.clear
        if type.lowercased() != "entertainment" {
            if dateText.count > 0 && dateText.contains(today) {
                self.todayIndicator.backgroundColor = UIColor.blue
            }
        }
    }
}
