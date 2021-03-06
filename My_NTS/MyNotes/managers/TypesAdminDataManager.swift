//
//  TypesAdminDataManager.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/30/21.
//

import UIKit

class TypesAdminDataManager: NSObject {
    
    static let sharedInstance = TypesAdminDataManager()
    
    var noteTypesList: [NoteTypes] = []
    
    func myNoteTypesData(completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.myNoteTypesData() { (any: Any) in
            DispatchQueue.main.async {
                let typesList = any as? [NoteTypes] ?? []
                self.noteTypesList.removeAll()
                self.noteTypesList.append(contentsOf: typesList)
                let value = true as Any
                completion(value)
            }
        }
    }
    
    func changeNoteTypesWithData(code: Int, item: NoteTypes, completion: @escaping  (Any)->()) {
        
        let typeId = item.id ?? "0"
        let name = item.name ?? ""
        
        let parameters: [String: Any] = ["id": (typeId as Any), "type": (name as Any)]
        
        DatasManager.sharedInstance.changeNoteTypesData(code: code, parameters: parameters) { (any: Any) in
            DispatchQueue.main.async {
                let typesList = any as? [NoteTypes] ?? []
                self.noteTypesList.removeAll()
                self.noteTypesList.append(contentsOf: typesList)
                let value: Any = true as Any
                completion(value)
            }
        }
    }
    
}
