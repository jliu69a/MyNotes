//
//  TypesAdminViewModel.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/30/21.
//

import UIKit
import SwiftyJSON


protocol TypesAdminViewModelDelegate: class {
    func didHaveAllTypesData()
}


class TypesAdminViewModel: NSObject {
    
    weak var delegate: TypesAdminViewModelDelegate?
    
    func totalSections() -> Int {
        return 1
    }
    
    func totalRowsInSection(index: Int) -> Int {
        return TypesAdminDataManager.sharedInstance.noteTypesList.count
    }
    
    func itemWithIndexPath(index: IndexPath) -> NoteTypes {
        return TypesAdminDataManager.sharedInstance.noteTypesList[index.row]
    }
}

extension TypesAdminViewModel {
    
    func allTypes() {
        TypesAdminDataManager.sharedInstance.myNoteTypesData() { (any: Any) in
            self.delegate?.didHaveAllTypesData()
        }
    }
}
