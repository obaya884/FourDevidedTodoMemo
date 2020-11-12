//
//  ModalViewController.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/05/02.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class AddModalViewController: UIViewController {
    
    private var presenter: AddModalPresenterInput!
    func inject(presenter: AddModalPresenterInput) {
        self.presenter = presenter
    }
    
    var sectionPickerView: UIPickerView = UIPickerView()
    
    @IBOutlet var sectionTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextField.delegate = self
        sectionTextField.delegate = self
        
        sectionPickerView.delegate = self
        sectionPickerView.dataSource = self

        setUpTextField(textField: contentTextField)
        setUpTextField(textField: sectionTextField)
        setUpSectionPickerView()
    }

    func setUpTextField(textField: UITextField) {
        textField.returnKeyType = .done
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func setUpSectionPickerView() {
        //PickerView ToolBar Setings
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        // sectionTextField input settings
        self.sectionTextField.inputView = sectionPickerView
        self.sectionTextField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        self.sectionTextField.endEditing(true)
    }

    @IBAction func pushAddButton(){
        if (sectionTextField.text == "" && contentTextField.text == ""){
            sectionTextField.layer.borderColor = UIColor.red.cgColor
            contentTextField.layer.borderColor = UIColor.red.cgColor
        }
        else if(sectionTextField.text == "" && contentTextField.text != ""){
            sectionTextField.layer.borderColor = UIColor.red.cgColor
            contentTextField.layer.borderColor = UIColor.black.cgColor
        }
        else if(sectionTextField.text != "" && contentTextField.text == ""){
            sectionTextField.layer.borderColor = UIColor.black.cgColor
            contentTextField.layer.borderColor = UIColor.red.cgColor
        }
        else{
            var sectionTag: Int = 0
            for sectionName in presenter.sectionNames{
                if(sectionTextField.text == sectionName){
                    sectionTag = presenter.sectionNames.firstIndex(of: sectionName)!
                }
            }
            let content: String = self.contentTextField.text!
            presenter.addItem(sectionIndex: sectionTag, content: content)
          
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddModalViewController: AddModalPresenterOutput {
    func dismissDialog() {
        
    }
}

extension AddModalViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(self.sectionTextField.text == ""){
            self.sectionTextField.text = presenter.sectionName(index: 0)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" {
            textField.layer.borderColor = UIColor.black.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.layer.borderColor = UIColor.black.cgColor
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.layer.borderColor = UIColor.red.cgColor
            return false
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- PickerView Settings
extension AddModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.sectionNamesOfItems
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.sectionName(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sectionTextField.text = presenter.sectionName(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
