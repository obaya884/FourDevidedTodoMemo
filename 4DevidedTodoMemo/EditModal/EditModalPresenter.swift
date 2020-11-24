//
//  EditModalPresenter.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/14.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import Foundation

protocol EditModalPresenterInput {
    var sectionNames:[String]{get}
    var sectionNamesOfItems: Int{get}
    func selectedItem() -> String
    func selectedSectoin() -> String
    func sectionName(index: Int) -> String?
    func editItem(sectionIndex: Int, content: String)
}

protocol EditModalPresenterOutput: AnyObject {
    func dismissDialog()
}

final class EditModalPresenter: EditModalPresenterInput {

    private(set) var sectionNames: [String] = []
    
    var sectionNamesOfItems: Int {
        sectionNames.count
    }
    
    private weak var view: EditModalPresenterOutput!
    private var model: ItemModelInput
    private var index: Int = 0
    private var sectionTag: Int = 0
    
    init(view: EditModalPresenterOutput, model: ItemModelInput, at index: Int, sectionTag: Int) {
        self.view = view
        self.model = model
        self.index = index
        self.sectionTag = sectionTag
        
        sectionNames = model.fetchSectionNames()
    }
    
    func selectedItem() -> String {
        return model.item(index: index, tag: sectionTag)
    }
    
    func selectedSectoin() -> String {
        return model.fetchSectionName(tag: sectionTag)
    }
    
    func sectionName(index: Int) -> String? {
        guard index < sectionNames.count else {return nil}
        return sectionNames[index]
    }

    func editItem(sectionIndex: Int, content: String) {
//        model.addItem(tag: sectionIndex, content: content, completion: model.notify)
    }

}
