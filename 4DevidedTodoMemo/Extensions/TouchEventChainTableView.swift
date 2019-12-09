//
//  TouchEventChainTableView.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/03.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import Foundation
import UIKit

class TouchEventChainTableView: UITableView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touchesBeganを次のResponderへ
        self.next?.touchesBegan(touches, with: event)
    }
}