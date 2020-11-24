//
//  EditModalViewController.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/14.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import UIKit

class EditModalViewController: UIViewController {
    
    private var presenter: EditModalPresenterInput!
    func inject(presenter: EditModalPresenterInput) {
        self.presenter = presenter
    }
    
    weak var modalView: UIView!
    var sectionPickerView: UIPickerView = UIPickerView()
    
    @IBOutlet var sectionTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!

    override func loadView() {
        super.loadView()
        
        modalView = UINib(nibName: "ModalView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        view.addSubview(modalView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        modalView.frame = self.view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeButton.setTitle("完了", for: .normal)
        completeButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        contentTextField.delegate = self
        sectionTextField.delegate = self
        
        sectionPickerView.delegate = self
        sectionPickerView.dataSource = self

        setUpTextField(textField: contentTextField)
        setUpTextField(textField: sectionTextField)
        setUpSectionPickerView()
        
        contentTextField.text = presenter.selectedItem()
        sectionTextField.text = presenter.selectedSectoin()
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

    @objc func tapButton(){
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
            presenter.editItem(newItemSectionTag: sectionTag, content: content)
            
            self.dismissDialog()
        }
    }
}

extension EditModalViewController: EditModalPresenterOutput {
    func dismissDialog() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditModalViewController: UITextFieldDelegate {
    
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
extension EditModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
