//
//  SharedHelper.swift
//  MyNotes
//
//  Created by Johnson Liu on 3/6/24.
//

import UIKit

class SharedHelper: NSObject {
    
    func escapeForHTMLCharacters(line: String) -> String {
        
        if line.count == 0 {
            return line
        }
        
        var parametersLine = line
        parametersLine = parametersLine.trimmingCharacters(in: .whitespacesAndNewlines)
        parametersLine = parametersLine.replacingOccurrences(of: "&", with: "*and*")
        parametersLine = parametersLine.replacingOccurrences(of: "+", with: "*plus*")
        parametersLine = parametersLine.replacingOccurrences(of: " ", with: "+")
        
        return parametersLine
    }
    
}
