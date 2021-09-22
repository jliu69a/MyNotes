//
//  TypesEditViewModel.swift
//  MyNotes
//
//  Created by Johnson Liu on 6/11/21.
//

import UIKit


protocol TypesEditViewModelDelegate: class {
    func didSaveChanges()
}


class TypesEditViewModel: NSObject {
    
    weak var delegate: TypesEditViewModelDelegate?
    
    func changeType(isNew: Bool, item: NoteTypes) {
        let code = isNew ? DatasManager.sharedInstance.kInsertCode : DatasManager.sharedInstance.kUpdateCode
        TypesAdminDataManager.sharedInstance.changeNoteTypesWithData(code: code, item: item) { (any: Any) in
            self.delegate?.didSaveChanges()
        }
    }
}
