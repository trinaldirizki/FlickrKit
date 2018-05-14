//
//  SearchHistoryManager.swift
//  FlickrSearch
//
//  Created by Sanju Naik on 6/16/17.
//  Copyright © 2017 Sanju. All rights reserved.
//

import UIKit

class SearchHistoryManager: NSObject {

    static let historyKey = "searchHistory"
    static var history = [String]()
    
    static func save() -> Void {
        UserDefaults.standard.set(history, forKey: historyKey)
        UserDefaults.standard.synchronize()
    }
    
    static func fetch() -> Void {
        if let hitoryArray = UserDefaults.standard.object(forKey: historyKey) as? [String] {
            history = hitoryArray
        }
    }
    
    static func add(text: String) {
        if !history.contains(text) {
            history.append(text)
        }
    }
}
