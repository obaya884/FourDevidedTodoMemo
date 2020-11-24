//
//  ModalView.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2020/11/14.
//  Copyright © 2020 TakumiObayashi. All rights reserved.
//

import UIKit

class ModalView: UIView {
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}
