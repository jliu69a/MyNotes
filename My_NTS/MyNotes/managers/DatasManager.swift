//
//  DatasManager.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/10/21.
//

import UIKit
import SwiftyJSON

class DatasManager: NSObject {
    
    static let sharedInstance = DatasManager()
    
    let kInsertCode: Int = 1
    let kUpdateCode: Int = 2
    let kDeleteCode: Int = 3
    
    let kInsertTypeCode: Int = 1
    let kUpdateTypeCode: Int = 2
    let kDeleteTypeCode: Int = 3
    
    //MARK: -
    
    func myNotesData(completion: @escaping  (Any)->()) {
        
        let url: String = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_all.php"
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                let myNotesList: [MyNotesData] = self.parseMyNotesData(data: rawData)
                let value: Any = myNotesList as Any
                completion(value)
            }
        }
    }
    
    func changeNotesData(code: Int, parameters: [String: Any], completion: @escaping  (Any)->()) {
        
        var url: String = ""
        switch code {
        case kInsertCode:
            url = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_insert.php"
            break
        case kUpdateCode:
            url = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_update.php"
            break
        case kDeleteCode:
            url = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_delete.php"
            break
        default:
            break
        }
        
        let connect: ConnectionsManager = ConnectionsManager()
        connect.saveDataFromUrl(url: url, parameters: parameters) { (data: Any) in
            if let rawData = data as? Data {
                let myNotesList: [MyNotesData] = self.parseMyNotesData(data: rawData)
                let value: Any = myNotesList as Any
                completion(value)
            }
        }
    }
    
    func parseMyNotesData(data: Data) -> [MyNotesData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("-> my notes : No Data")
            return []
        }
        
        var dataList: [MyNotesData] = []
        do {
            dataList = try JSONDecoder().decode([MyNotesData].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: -
    
    func myNoteTotalTypes(completion: @escaping  (Any)->()) {
        
        let url: String = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_types_total.php"
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                let totalTypesList: [NoteTotals] = self.parseTotalsData(data: rawData)
                let value: Any = totalTypesList as Any
                completion(value)
            }
        }
    }
    
    func parseTotalsData(data: Data) -> [NoteTotals] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("-> total types : No Data")
            return []
        }
        
        var dataList: [NoteTotals] = []
        do {
            dataList = try JSONDecoder().decode([NoteTotals].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: -
    
    func myNoteTypesData(completion: @escaping  (Any)->()) {
        
        let url: String = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_all_types.php"
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                let myNotesList: [NoteTypes] = self.parseMyNoteTypesData(data: rawData)
                let value: Any = myNotesList as Any
                completion(value)
            }
        }
    }
    
    func changeNoteTypesData(code: Int, parameters: [String: Any], completion: @escaping  (Any)->()) {
        
        var url: String = ""
        switch code {
        case kInsertTypeCode:
            url = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_insert_type.php"
            break
        case kUpdateTypeCode:
            url = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_update_type.php"
            break
        case kDeleteTypeCode:
            url = "http://www.mysohoplace.com/php_hdb/php_MyNotes/my_notes_delete_type.php"
            break
        default:
            break
        }
        
        let connect: ConnectionsManager = ConnectionsManager()
        connect.saveDataFromUrl(url: url, parameters: parameters) { (data: Any) in
            if let rawData = data as? Data {
                let myNotesList: [NoteTypes] = self.parseMyNoteTypesData(data: rawData)
                let value: Any = myNotesList as Any
                completion(value)
            }
        }
    }
    
    func parseMyNoteTypesData(data: Data) -> [NoteTypes] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("-> my note types : No Data")
            return []
        }
        
        var dataList: [NoteTypes] = []
        do {
            dataList = try JSONDecoder().decode([NoteTypes].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
}
