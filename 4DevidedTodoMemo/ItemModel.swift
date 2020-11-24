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
    func fetchSectionNames() -> [String]
    func fetchItems(tag: Int) -> [String]
    func item(index: Int, tag: Int) -> String
    func addItem(tag: Int, content: String, completion: @escaping () -> Void)
    func editItem(preSectionTag: Int, newSectionTag: Int, preItemIndex: Int, content: String, completion: @escaping () -> Void)
    func deleteItem(tag: Int, index: Int, completion: @escaping () -> Void)
    
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
    
    func fetchSectionNames() -> [String] {
        var sectionNames: [String] = []
        sectionNames.append(userDefaults.object(forKey: "topLeftSectionName") as? String ?? "")
        sectionNames.append(userDefaults.object(forKey: "topRightSectionName") as? String ?? "")
        sectionNames.append(userDefaults.object(forKey: "bottomLeftSectionName") as? String ?? "")
        sectionNames.append(userDefaults.object(forKey: "bottomRightSectionName") as? String ?? "")
        return sectionNames
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
    
    func item(index: Int, tag: Int) -> String {
        var items: [String] = []
        
        switch tag {
        case 0:
            items = userDefaults.array(forKey: "topLeftSectionItemName") as? [String] ?? []
        case 1:
            items = userDefaults.array(forKey: "topRightSectionItemName") as? [String] ?? []
        case 2:
            items = userDefaults.array(forKey: "bottomLeftSectionItemName") as? [String] ?? []
        case 3:
            items = userDefaults.array(forKey: "bottomRightSectionItemName") as? [String] ?? []
        default:
            break
        }
        return items[index]
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
    
    func editItem(preSectionTag: Int, newSectionTag: Int, preItemIndex: Int, content: String, completion: @escaping () -> Void) {
        if preSectionTag == newSectionTag {
            var keyName = ""
            var items: [String]
            switch preSectionTag {
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
            items.insert(content, at: preItemIndex)
            items.remove(at: preItemIndex + 1)
            userDefaults.set(items, forKey: keyName)
        }
        else {
            var preSectionKeyName: String
            var preSectionItems: [String]
            switch preSectionTag {
            case 0:
                preSectionKeyName = "topLeftSectionItemName"
            case 1:
                preSectionKeyName = "topRightSectionItemName"
            case 2:
                preSectionKeyName = "bottomLeftSectionItemName"
            case 3:
                preSectionKeyName = "bottomRightSectionItemName"
            default:
                preSectionKeyName = ""
            }
            preSectionItems = userDefaults.array(forKey: preSectionKeyName) as? [String] ?? []

            var newSectionKeyName: String
            var newSectionItems: [String]
            switch newSectionTag {
            case 0:
                newSectionKeyName = "topLeftSectionItemName"
            case 1:
                newSectionKeyName = "topRightSectionItemName"
            case 2:
                newSectionKeyName = "bottomLeftSectionItemName"
            case 3:
                newSectionKeyName = "bottomRightSectionItemName"
            default:
                newSectionKeyName = ""
            }
            newSectionItems = userDefaults.array(forKey: newSectionKeyName) as? [String] ?? []
            
            preSectionItems.remove(at: preItemIndex)
            userDefaults.set(preSectionItems, forKey: preSectionKeyName)
            
            newSectionItems.insert(content, at: 0)
            userDefaults.set(newSectionItems, forKey: newSectionKeyName)
            
        }
        
        // 描画更新通知
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            completion()
        }

    }
    
    func deleteItem(tag: Int, index: Int, completion: @escaping () -> Void) {
        var keyName = ""
        
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
        items.remove(at: index)
        userDefaults.set(items, forKey: keyName)
        
        // 描画更新通知
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            completion()
        }
    }
    
}
