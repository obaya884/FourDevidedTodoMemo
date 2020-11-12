//
//  AddModalPresenter.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/10.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import Foundation

protocol AddModalPresenterInput {
    func addItem(sectionIndex: Int, content: String)
}

protocol AddModalPresenterOutput: AnyObject {
    func dismissDialog()
}

final class AddModalPresenter: AddModalPresenterInput {
    private weak var view: AddModalPresenterOutput!
    private var model: ItemModelInput
    
    init(view: AddModalPresenterOutput, model: ItemModelInput) {
        self.view = view
        self.model = model
    }
    
    func addItem(sectionIndex: Int, content: String) {
        model.addItem(tag: sectionIndex, content: content, completion: model.notify)
    }

}
