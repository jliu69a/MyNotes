//
//  ConnectionsManager.swift
//  MyNotes
//
//  Created by Johnson Liu on 5/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON


class ConnectionsManager: NSObject {
    
    //MARK: - APIs
    
    func getJsonFromUrl(url: String, completion: @escaping (_ json: JSON) -> Void) {
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let json = JSON(rawValue: value) {
                    completion(json)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    func getDataFromUrl(url: String, completion: @escaping (_ data: Any) -> Void) {
        
        AF.request(url).responseData { response in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    func saveDataFromUrl(url: String, parameters: String, completion: @escaping (_ data: Any) -> Void) {
        
        AF.request(url).responseData { response in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
