//
//  LongPressEditableTextField.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/03.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class EditingStyleChangeTextField: UITextField {
    
    override func awakeFromNib() {
        
        self.enabled = false
        // UILongPressGestureRecognizerのインスタンス生成
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.LongPressed(recognizer: )))

        // TextField自身にrecognizerを設定
        addGestureRecognizer(longPressRecognizer)

    }
    
    
    
    @objc func LongPressed(recognizer: UILongPressGestureRecognizer){
        if( recognizer.state == UIGestureRecognizer.State.began){
            print(self.text!)
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
