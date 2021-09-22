//
//  HomeHeaderController.swift
//  MyNotes
//
//  Created by Johnson Liu on 6/19/21.
//

import UIKit

class HomeHeaderController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var headerButton: UIButton!
    
    weak var parentVC: HomeViewController? = nil
    
    var sectionIndex: Int = 0
    var isRowsExpanded: Bool = false
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayData(section: Int, title: String, isExpanded: Bool) {
        
        bgView.layer.borderColor = UIColor.black.cgColor
        bgView.layer.borderWidth = 0.5
        
        headerButton.addTarget(self, action: #selector(selectToChange), for: .touchUpInside)
        
        titleLabel.text = title
        sectionIndex = section
        isRowsExpanded = isExpanded
        showHeaderImage(isExpanded: isRowsExpanded)
    }
    
    func showHeaderImage(isExpanded: Bool) {
        
        if isExpanded {
            titleImage.image = UIImage(systemName: "arrow.up.circle")
        }
        else {
            titleImage.image = UIImage(systemName: "arrow.down.circle")
        }
    }
    
    @objc func selectToChange() {
        isRowsExpanded = !isRowsExpanded
        showHeaderImage(isExpanded: isRowsExpanded)
        parentVC?.changeListingsDisplay(section: sectionIndex, isExpanded: isRowsExpanded)
    }
}
