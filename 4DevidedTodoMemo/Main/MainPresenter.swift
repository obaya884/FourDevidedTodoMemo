//
//  MainPresenter.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/10.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import Foundation

protocol MainPresenterInput {
    var topLeftNumberOfItems: Int{get}
    var topRightNumberOfItems: Int{get}
    var bottomLeftNumberOfItems: Int{get}
    var bottomRightNumberOfItems: Int{get}
    
    func item(forRow row: Int, tag: Int) -> String?
    func didSelectRow(at indexPath: IndexPath)
}

protocol MainPresenterOutput: AnyObject {
    
}

final class MainPresenter: MainPresenterInput {
    private(set) var topLeftItems: [String] = []
    private(set) var topRightItems: [String] = []
    private(set) var bottomLeftItems: [String] = []
    private(set) var bottomRightItems: [String] = []
    
    private weak var view: MainPresenterOutput!
    private var model: MainModelInput
    
    init(view: MainPresenterOutput, model: MainModelInput) {
        self.view = view
        self.model = model
        
        topLeftItems = model.fetchItems(tag: 0) ?? []
        topRightItems = model.fetchItems(tag: 1) ?? []
        bottomLeftItems = model.fetchItems(tag: 2) ?? []
        bottomRightItems = model.fetchItems(tag: 3) ?? []
    }
    
    var topLeftNumberOfItems: Int {
        topLeftItems.count
    }
    
    var topRightNumberOfItems: Int {
        topRightItems.count
    }
    
    var bottomLeftNumberOfItems: Int {
        bottomLeftItems.count
    }
    
    var bottomRightNumberOfItems: Int {
        bottomRightItems.count
    }
    
    func item(forRow row: Int, tag: Int) -> String? {
        var items: [String] = []
        
        switch tag {
        case 0:
            items = topLeftItems
        case 1:
            items = topRightItems
        case 2:
            items = bottomLeftItems
        case 3:
            items = bottomRightItems
        default:
            break
        }
        
        guard row < items.count else { return nil }
        return items[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        // TODO:  編集機能の実装
    }
    
    
}
