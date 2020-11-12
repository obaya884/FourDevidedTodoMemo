//
//  MainModel.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/10.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import Foundation

protocol ItemModelInput {
    func fetchSectionName(tag: Int) -> String
    func fetchItems(tag: Int) -> [String]
    func addItem(tag: Int, content: String, completion: @escaping () -> Void)
    func editItem(tag: Int, index: Int, content: String)
    func deleteItem(tag: Int, index: Int)
    
    func notify()
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserber(_ observer: Any)
}

final class ItemModel: ItemModelInput {
    
    let userDefaults = UserDefaults.standard
    
    var notificationName: Notification.Name {
        return Notification.Name(rawValue: "ItemModel")
    }
    
    func notify() {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
    
    func removeObserber(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func fetchSectionName(tag: Int) -> String {
        switch tag {
        case 0:
            return userDefaults.object(forKey: "topLeftSectionName") as? String ?? ""
        case 1:
            return userDefaults.object(forKey: "topRightSectionName") as? String ?? ""
        case 2:
            return userDefaults.object(forKey: "bottomLeftSectionName") as? String ?? ""
        case 3:
            return userDefaults.object(forKey: "bottomRightSectionName") as? String ?? ""
        default:
            return ""
        }
    }
    
    func fetchItems(tag: Int) -> [String] {
        switch tag {
        case 0:
            return userDefaults.array(forKey: "topLeftSectionItemName") as? [String] ?? []
        case 1:
            return userDefaults.array(forKey: "topRightSectionItemName") as? [String] ?? []
        case 2:
            return userDefaults.array(forKey: "bottomLeftSectionItemName") as? [String] ?? []
        case 3:
            return userDefaults.array(forKey: "bottomRightSectionItemName") as? [String] ?? []
        default:
            return []
        }
    }
    
    func addItem(tag: Int, content: String, completion: @escaping () -> Void) {
        var keyName = ""
        
        // 追加処理
        var items: [String]
        switch tag {
        case 0:
            keyName = "topLeftSectionItemName"
        case 1:
            keyName = "topRightSectionItemName"
        case 2:
            keyName = "bottomLeftSectionItemName"
        case 3:
            keyName = "bottomRightSectionItemName"
        default:
            keyName = ""
        }
        items = userDefaults.array(forKey: keyName) as? [String] ?? []
        items.insert(content, at: 0)
        userDefaults.set(items, forKey: keyName)
        
        // 描画更新通知
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            completion()
        }
    }
    
    func editItem(tag: Int, index: Int, content: String) {
        
    }
    
    func deleteItem(tag: Int, index: Int) {
        
    }
    
}
