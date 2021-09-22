//
//  HomeViewModel.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/12/21.
//

import UIKit
import SwiftyJSON


protocol HomeViewModelDelegate: AnyObject {
    func didHaveAllNotesData()
}


class HomeViewModel: NSObject {
    
    weak var delegate: HomeViewModelDelegate?
    
    var isListingAll = false
    
    func totalSections() -> Int {
        
        if isListingAll {
            return 1
        }
        else {
            return MyNotesDataManager.sharedInstance.notesDisplayList.count
        }
    }
    
    func totalRowsInSection(index: Int) -> Int {
        
        if isListingAll {
            return MyNotesDataManager.sharedInstance.notesDisplayAllList.count
        }
        else {
            var totalRows = 0
            if index < MyNotesDataManager.sharedInstance.expandFlagsList.count {
                if MyNotesDataManager.sharedInstance.expandFlagsList[index] {
                    let title = MyNotesDataManager.sharedInstance.notesDisplayList[index]
                    let array = MyNotesDataManager.sharedInstance.notesDisplayData[title] ?? []
                    totalRows = array.count
                }
            }
            return totalRows
        }
    }
    
    func itemWithIndexPath(index: IndexPath) -> Notes {
        
        if isListingAll {
            return MyNotesDataManager.sharedInstance.notesDisplayAllList[index.row]
        }
        else {
            let title = MyNotesDataManager.sharedInstance.notesDisplayList[index.section]
            let array = MyNotesDataManager.sharedInstance.notesDisplayData[title] ?? []
            return array[index.row]
        }
    }
    
    func heightForSectionHeater(section: Int) -> CGFloat {
        return isListingAll ? 0 : 40
    }
    
    func titleForSection(index: Int) -> String {
        
        if isListingAll {
            return ""
        }
        else {
            if index < MyNotesDataManager.sharedInstance.notesDisplayList.count {
                return MyNotesDataManager.sharedInstance.notesDisplayList[index]
            }
            else {
                return ""
            }
        }
    }
    
    
    func headerView(frame: CGRect, section: Int, title: String, parentVC: HomeViewController) -> UIView? {
        var headerView: UIView? = nil
        
        if !isListingAll {
            let headerStoryboard = UIStoryboard(name: "home", bundle: nil)
            let headerWidth = frame.size.width
            let headerHeight = CGFloat(70)
            
            var expandFlag = false
            if section < MyNotesDataManager.sharedInstance.expandFlagsList.count {
                expandFlag = MyNotesDataManager.sharedInstance.expandFlagsList[section]
            }
            
            if let vc = headerStoryboard.instantiateViewController(identifier: "HomeHeaderController") as? HomeHeaderController {
                vc.parentVC = parentVC
                vc.view.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)
                vc.displayData(section: section, title: title, isExpanded: expandFlag)
                parentVC.addChild(vc)
                headerView = vc.view
            }
        }
        return headerView
    }
    
}

//MARK: -

extension HomeViewModel {
    
    func allNotes() {
        MyNotesDataManager.sharedInstance.myNotesData() { (any: Any) in
            self.delegate?.didHaveAllNotesData()
        }
    }
    
    func changeExpandFlag(sectionIndex: Int) {
        if sectionIndex < MyNotesDataManager.sharedInstance.expandFlagsList.count {
            let currentFlag = MyNotesDataManager.sharedInstance.expandFlagsList[sectionIndex]
            MyNotesDataManager.sharedInstance.expandFlagsList[sectionIndex] = !currentFlag
        }
    }
    
}
