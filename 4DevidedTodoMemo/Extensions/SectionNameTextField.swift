//
//  EditingStyleChangeEditableTextField.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/03.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class SectionNameTextField: UITextField, UITextFieldDelegate {
    
    override func draw(_ rect: CGRect) {
        self.delegate = self
        self.borderStyle = .none
        self.returnKeyType = .done
        self.adjustsFontSizeToFitWidth = true
        self.minimumFontSize = 8
     }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .white
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.text != "" {
            self.layer.borderColor = UIColor.black.cgColor
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.text == "" {
            self.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else{
            //UserDefaultsの登録を上書き
            let userDefaults: UserDefaults = UserDefaults.standard
            switch tag {
            case 0:
                userDefaults.set(self.text, forKey: "topLeftSectionName")
            case 1:
                userDefaults.set(self.text, forKey: "topRightSectionName")
            case 2:
                userDefaults.set(self.text, forKey: "bottomLeftSectionName")
            case 3:
                userDefaults.set(self.text, forKey: "bottomRightSectionName")
            default:
                break
            }
        return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderWidth = 0
        self.backgroundColor = .clear
    }
    
    //範囲外タップでキーボードを下げる
    //→viewcontrollerで実装
}
