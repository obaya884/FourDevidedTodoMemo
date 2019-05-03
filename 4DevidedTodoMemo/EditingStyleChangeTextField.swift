//
//  LongPressEditableTextField.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/03.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class LongPressEditableTextField: UITextField, UITextFieldDelegate {
    
    override func awakeFromNib() {
        self.delegate = self
        self.borderStyle = .none
        
        // Keyboard Setting
        self.returnKeyType = .done
        
    }
    
    /// テキストフィールド入力状態後
    ///
    /// - Parameter textField: 対象のテキストフィールド
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("テキストフィールド入力状態後")
        self.borderStyle = .roundedRect
        self.backgroundColor = .white
    }
    
    /// フォーカスが外れた後
    ///
    /// - Parameter textField: 対象のテキストフィールド
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("フォーカスが外れた後")
        self.borderStyle = .none
        self.backgroundColor = .clear
    }
    
    // 完了ボタンでキーボードを下げる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    //範囲外タップでキーボードを下げる
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
