//
//  CustomTableViewCell.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/04/29.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit
import LTHRadioButton

protocol RadioButtonDelegate{
    func onSelectRadioButton(sender: LTHRadioButton)
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var radioButton: LTHRadioButton!
    @IBOutlet var taskLabel: UILabel!
    
    var delegate: RadioButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        radioButton.selectedColor = UIColor(hex: "FF8D3F")
        
        radioButton.onSelect { [unowned self] in
            //radioButtonのセレクトアニメーションが終わったくらいでセル削除処理
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.delegate?.onSelectRadioButton(sender: self.radioButton)
                
                // TableViewCellの再利用で悪さされるぽいので最後にdeselectしとく
                self.radioButton.deselect()
            }
        }
        
        radioButton.onDeselect{}
    }
    
}
