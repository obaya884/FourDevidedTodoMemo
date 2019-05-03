//
//  ModalViewController.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/02.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

protocol AddButtonDelegate {
    func afterPushModalViewAddButton(sectionTag: Int, content: String)
}

class ModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let sectionNameArray: [String] = ["生活", "仕事", "成長", "趣味"]
    var delegate: AddButtonDelegate?
    var sectionPickerView: UIPickerView = UIPickerView()
    
    @IBOutlet var sectionTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    
    @IBAction func pushAddButton(){
        if (sectionTextField.text == "" && contentTextField.text == ""){
            print("no section, no content")
            //            sectionTextField.backgroundColor = .red
            //            contentTextField.backgroundColor = .red
        }
        else if(sectionTextField.text == "" && contentTextField.text != ""){
            print("no section")
            //            sectionTextField.backgroundColor = .red
            
        }
        else if(sectionTextField.text != "" && contentTextField.text == ""){
            print("no content")
            //            contentTextField.backgroundColor = .red
            
        }
        else{
            var sectionTag: Int = 0
            for sectionName in sectionNameArray{
                if(sectionTextField.text == sectionName){
                    sectionTag = sectionNameArray.firstIndex(of: sectionName)!
                }
            }
            let content: String = self.contentTextField.text!
            
            //入力フォームのリセット
            self.sectionTextField.text = ""
            self.contentTextField.text = ""
            self.sectionPickerView.selectRow(0, inComponent: 0, animated: false)
            
            self.dismiss(animated: true, completion: nil)
            print(sectionTag, content)
            print("call delegate")
            self.delegate?.afterPushModalViewAddButton(sectionTag: sectionTag, content: content)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contentTextField.delegate = self
        sectionPickerView.delegate = self
        sectionPickerView.dataSource = self
        sectionPickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ModalViewController.done))
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        
        // sectionTextField settings
        self.sectionTextField.inputView = sectionPickerView
        self.sectionTextField.inputAccessoryView = toolbar
        self.sectionTextField.tintColor = .clear
        
        // ContentTextField Settings
        self.contentTextField.returnKeyType = .done
        
        // sectionPickerView Initial Setting
        self.sectionPickerView.selectRow(0, inComponent: 0, animated: false)
        
    }
    
    // MARK:- SectionTextField Settings
    @IBAction func setInitialValueOnSectionTextField() {
        if(self.sectionTextField.text == ""){
            self.sectionTextField.text = self.sectionNameArray[0]
        }
    }
    
    // MARK:- ContentTextField Settings
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.contentTextField.resignFirstResponder()
        return true
    }
    
    // MARK:- PickerView Settings
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectionNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sectionNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sectionTextField.text = sectionNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    @objc func done() {
        self.sectionTextField.endEditing(true)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.sectionTextField.endEditing(true)
//        self.contentTextField.endEditing(true)
//
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
