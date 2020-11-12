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
    func onSelectRadioButton(sectionTag: Int, itemIndex: Int)
    func transitionToAddModal()
    func receiveNotify()
}

protocol MainPresenterOutput: AnyObject {
    func updateItems()
    func popUpAddDialog()
}

final class MainPresenter: MainPresenterInput {
    
    private(set) var topLeftItems: [String] = []
    private(set) var topRightItems: [String] = []
    private(set) var bottomLeftItems: [String] = []
    private(set) var bottomRightItems: [String] = []
    
    private weak var view: MainPresenterOutput!
    private var model: ItemModelInput
    
    init(view: MainPresenterOutput, model: ItemModelInput) {
        self.view = view
        self.model = model
        
        model.addObserver(self, selector: #selector(self.receiveNotify))
        
        fetchAllItems()
    }
    
    func fetchAllItems() {
        topLeftItems = model.fetchItems(tag: 0)
        topRightItems = model.fetchItems(tag: 1)
        bottomLeftItems = model.fetchItems(tag: 2)
        bottomRightItems = model.fetchItems(tag: 3)
    }
    
    @objc func receiveNotify() {
        fetchAllItems()
        view.updateItems()
    }
    
    func transitionToAddModal() {
        view.popUpAddDialog()
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
    
    func onSelectRadioButton(sectionTag: Int, itemIndex: Int) {
        model.deleteItem(tag: sectionTag, index: itemIndex, completion: model.notify)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        // TODO:  編集機能の実装
    }
    
    
}
