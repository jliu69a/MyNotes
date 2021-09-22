//
//  jsonsData.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/10/21.
//

import UIKit


//MARK: - mappings

public struct MyNotesData: Codable {
    var types : [NoteTypes]?
    var notes : [Notes]?
}

//MARK: - types define

public struct NoteTypes: Codable {
    var id : String?
    var name : String?
}

public struct Notes: Codable {
    var id : String?
    var title : String?
    var type_id : String?
    var type_name : String?
    var update_date : String?
    var date_time: String?
    var content : String?
}
