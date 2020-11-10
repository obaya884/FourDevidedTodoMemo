//
//  MainModel.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/10.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import Foundation

protocol MainModelInput {
    func fetchItems(tag: Int) -> [String]?
}

final class MainModel: MainModelInput {
    let userDefaults = UserDefaults.standard
    
    func fetchItems(tag: Int) -> [String]? {
        switch tag {
        case 0:
            return userDefaults.array(forKey: "topLeftSectionItemName") as? [String]
        case 1:
            return userDefaults.array(forKey: "topRightSectionItemName") as? [String]
        case 2:
            return userDefaults.array(forKey: "bottomLeftSectionItemName") as? [String]
        case 3:
            return userDefaults.array(forKey: "bottomRightSectionItemName") as? [String]
        default:
            return nil
        }
    }
    
}
