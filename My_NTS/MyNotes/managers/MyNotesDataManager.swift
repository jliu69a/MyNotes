//
//  MyNotesDataManager.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/10/21.
//

import UIKit
import SwiftyJSON

//MARK: -

class MyNotesDataManager: NSObject {
    
    static let sharedInstance = MyNotesDataManager()
    
    let displayFormat = "yyyy-MM-dd,  hh:mm a  (E)"
    let itemFormat = "yyyy-MM-dd, HH:mm:ss"
    let currentFormat = "yyyy-MM-dd  (E)"
    let todayFormat = "yyyy-MM-dd"
    
    var notesList: [Notes] = []
    var noteTypesList: [NoteTypes] = []
    
    var notesDisplayList: [String] = []
    var notesDisplayData: [String: [Notes]] = [:]
    
    var notesDisplayAllList: [Notes] = []
    var expandFlagsList: [Bool] = []
    
    //MARK: - data functions
    
    func myNotesData(completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.myNotesData() { (any: Any) in
            DispatchQueue.main.async {
                let myNotesList = any as? [MyNotesData] ?? []
                self.processNotesData(data: myNotesList)
                let value: Any = true as Any
                completion(value)
            }
        }
    }
    
    func changeNotesWithData(code: Int, item: Notes, completion: @escaping  (Any)->()) {
        
        let noteId = item.id ?? "0"
        let title = item.title ?? ""
        let typeId = item.type_id ?? "0"
        let content = item.content ?? ""
        let dateTime = item.date_time ?? ""
        
        let parameters: [String: Any] = ["id": (noteId as Any), "title": (title as Any), "typeid": (typeId as Any), "datetime": (dateTime as Any), "content": (content as Any)]
        
        DatasManager.sharedInstance.changeNotesData(code: code, parameters: parameters) { (any: Any) in
            DispatchQueue.main.async {
                let myNotesList = any as? [MyNotesData] ?? []
                self.processNotesData(data: myNotesList)
                let value: Any = true as Any
                completion(value)
            }
        }
    }
    
    //MARK: - helper functions
    
    func processNotesData(data: [MyNotesData]) {
        self.notesList.removeAll()
        self.noteTypesList.removeAll()
        
        for each in data {
            if each.types != nil {
                self.noteTypesList = each.types ?? []
            }
            if each.notes != nil {
                self.notesList = each.notes ?? []
            }
        }
        self.allItemsList()
        self.parseNotesArray()
    }
    
    func allItemsList() {
        self.notesDisplayAllList.removeAll()
        
        if self.notesList.count == 0 {
            return
        }
        self.notesDisplayAllList = self.notesList.sorted(by: { ($0.date_time ?? "") > ($1.date_time ?? "") })
    }
    
    func parseNotesArray() {
        self.notesDisplayList.removeAll()
        self.notesDisplayData.removeAll()
        
        if self.notesList.count == 0 {
            return
        }
        self.notesDisplayData = Dictionary(grouping: self.notesList, by: { $0.type_name ?? "#" })
        let allKeys = Array(self.notesDisplayData.keys) as [String]
        self.notesDisplayList = allKeys.sorted()
        
        self.expandFlagsList.removeAll()
        for _ in self.notesDisplayList {
            self.expandFlagsList.append(true)  //-- initially all are expanded
        }
    }
    
    func typeNameWithId(id: String) -> String {
        
        let typeItem = self.noteTypesList.filter{ $0.id == id }.first ?? NoteTypes()
        return typeItem.name ?? ""
    }
    
    func colorForType(type: String) -> UIColor {
        var color = UIColor.black
        
        switch type.lowercased() {
        case "business":
            color = UIColor.black
            break
        case "company":
            color = UIColor.systemRed
            break
        case "recruiter":
            color = UIColor.systemBlue
            break
        case "entertainment":
            color = UIColor.systemPurple
            break
        case "personal":
            color = UIColor.systemOrange
            break
        default:
            break
        }
        
        return color
    }
}

//MARK: -

extension MyNotesDataManager {
    
    func formatDisplayDate(dateText: String, oldFormat: String? = nil, newFormat: String? = nil) -> String {
        
        let oldFormatText = (oldFormat == nil) ? "yyyy-MM-dd HH:mm:ss.000000" : (oldFormat ?? "")
        let newFormatText = (newFormat == nil) ? "MM/dd/yyyy,  hh:mm:ss a  (E)" : (newFormat ?? "")
        
        let df = DateFormatter()
        df.dateFormat = oldFormatText //"yyyy-MM-dd HH:mm:ss.000000"
        let notesDate = df.date(from: dateText) ?? Date()
        
        df.dateFormat = newFormatText //"MM/dd/yyyy,  hh:mm:ss a  (E)"
        return df.string(from: notesDate)
    }
    
    func displayDateWithFormat(format: String, date: Date) -> String {
        
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: date)
    }
    
    func textToDate(dateText: String) -> Date {
        
        let df = DateFormatter()
        df.dateFormat = itemFormat
        return df.date(from: dateText) ?? Date()
    }
    
    func changeToDisplay(dateText: String) -> String {
        
        let date = self.textToDate(dateText: dateText)
        let df = DateFormatter()
        df.dateFormat = displayFormat
        return df.string(from: date)
    }
    
    func currentDisplayDate() -> String {
        
        let df = DateFormatter()
        df.dateFormat = currentFormat
        return df.string(from: Date())
    }
    
    func todayDate() -> String {
        
        let df = DateFormatter()
        df.dateFormat = todayFormat
        return df.string(from: Date())
    }
}
