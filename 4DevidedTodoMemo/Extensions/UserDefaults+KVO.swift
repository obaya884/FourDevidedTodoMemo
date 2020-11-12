//
//  UserDefaults+KVO.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/10.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import Foundation

extension UserDefaults {
    @objc dynamic var topLeftSectionName: [String] {
        return [String](arrayLiteral: "topLeftSectionName")
    }
}
