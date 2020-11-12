//
//  MainViewController.swift
//  4DevidedItemNameMemo
//
//  Created by 大林拓実 on 2019/04/28.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit
import LTHRadioButton
import PopupDialog

class MainViewController: UIViewController{
    
    private var presenter: MainPresenterInput!
    func inject(presenter: MainPresenterInput) {
        self.presenter = presenter
    }
    
    //MARK:- Initialization
    //アウトレット変数
    @IBOutlet var topLeftSectionNameTextField: UITextField!
    @IBOutlet var topRightSectionNameTextField: UITextField!
    @IBOutlet var bottomLeftSectionNameTextField: UITextField!
    @IBOutlet var bottomRightSectionNameTextField: UITextField!
    
    @IBOutlet var topLeftSectionTableView: UITableView!
    @IBOutlet var topRightSectionTableView: UITableView!
    @IBOutlet var bottomLeftSectionTableView: UITableView!
    @IBOutlet var bottomRightSectionTableView: UITableView!
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //TableViewのdelegateとdatasource設定
        topLeftSectionTableView.dataSource = self
        topRightSectionTableView.dataSource = self
        bottomLeftSectionTableView.dataSource = self
        bottomRightSectionTableView.dataSource = self
        
        //UserDefaultのインスタンス生成
        let userDefaults: UserDefaults = UserDefaults.standard
        
        //TableViewのカスタムセル登録
        self.topLeftSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.topRightSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.bottomLeftSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.bottomRightSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        topLeftSectionTableView.estimatedRowHeight = 44
        topRightSectionTableView.estimatedRowHeight = 44
        bottomLeftSectionTableView.estimatedRowHeight = 44
        bottomRightSectionTableView.estimatedRowHeight = 44
        
        topLeftSectionTableView.rowHeight = UITableView.automaticDimension
        topRightSectionTableView.rowHeight = UITableView.automaticDimension
        bottomLeftSectionTableView.rowHeight = UITableView.automaticDimension
        bottomRightSectionTableView.rowHeight = UITableView.automaticDimension
        
        //SectionNameTextFieldの値を取得
        self.topLeftSectionNameTextField.text = presenter.topLeftSectionName
        self.topRightSectionNameTextField.text = presenter.topRightSectionName
        self.bottomLeftSectionNameTextField.text = presenter.bottomLeftSectionName
        self.bottomRightSectionNameTextField.text = presenter.bottomRightSectionName
    
        // TODO: ウォークスルーの実現検討
        //初期値の設定（チュートリアル説明用）
        //        userDefaults.register(defaults:
        //            ["topLeftSectionItemName": ["Tetraへようこそ！", "中央のプラスボタンから", "TODOを追加できます"],
        //             "topRightSectionItemName": ["←のボックスをタップすると", "TODOを消すことができます"],
        //             "bottomLeftSectionItemName": ["TetraではTODOを", "4つの領域に分類します"],
        //             "bottomRightSectionItemName": ["領域の名前をタップすると", "領域名を変更できます", "それではTetraをお楽しみください！"]
        //            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.topLeftSectionTableView.flashScrollIndicators()
        self.topRightSectionTableView.flashScrollIndicators()
        self.bottomLeftSectionTableView.flashScrollIndicators()
        self.bottomRightSectionTableView.flashScrollIndicators()
    }
    
    //タスク追加ボタン押下時のメソッド(PopupDialogを用いたモーダル表示）
    @IBAction func tapPlusButton(){
        presenter.transitionToAddModal()
    }
    
    //画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //どのtextfield編集に対しても閉じれるようにviewに対してendEditngする
        self.view.endEditing(true)
    }
    
    // tableviewの処理を分岐するメソッド
    func checkTableView(_ tableView: UITableView) -> Int{
        var tag: Int = 0
        if (tableView.isEqual(topLeftSectionTableView)) {
            tag = 0
        }
        else if (tableView.isEqual(topRightSectionTableView)) {
            tag = 1
        }
        else if (tableView.isEqual(bottomLeftSectionTableView)) {
            tag = 2
        }
        else if (tableView.isEqual(bottomRightSectionTableView)){
            tag = 3
        }
        return tag
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch checkTableView(tableView) {
        case 0:
            return presenter.topLeftNumberOfItems
        case 1:
            return presenter.topRightNumberOfItems
        case 2:
            return presenter.bottomLeftNumberOfItems
        case 3:
            return presenter.bottomRightNumberOfItems
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 44
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        //cellのRadioButtonDelegate実装先の設定
        cell.delegate = self
        
        if let item = presenter.item(forRow: indexPath.row, tag: checkTableView(tableView)) {
            cell.configure(item: item)
        }
        
        return cell
    }
    
}

extension MainViewController: MainPresenterOutput {
    func updateItems() {
        topLeftSectionTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        topRightSectionTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        bottomLeftSectionTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        bottomRightSectionTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func popUpAddDialog() {
        let addModal = AddModalViewController(nibName: "ModalViewController", bundle: nil)
        let model = ItemModel()
        let addModalPresenter = AddModalPresenter(view: addModal, model: model)
        addModal.inject(presenter: addModalPresenter)
        
        //モーダル外のオーバーレイ表示の設定
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color           = .white
        overlayAppearance.blurRadius      = 5
        overlayAppearance.blurEnabled     = true
        overlayAppearance.liveBlurEnabled = false
        overlayAppearance.opacity         = 0.2
        
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: addModal, transitionStyle: .zoomIn)
        
        // SectionNameが全て存在している状態であれば作成したポップアップを表示する
        if ( topLeftSectionNameTextField.text != "" &&
                topRightSectionNameTextField.text != "" &&
                bottomLeftSectionNameTextField.text != "" &&
                bottomRightSectionNameTextField.text != "") {
            self.view.endEditing(true)
            present(popup, animated: true, completion: nil)
        }
    }
    
}

// MARK: RadioButtonDelegate
extension MainViewController: RadioButtonDelegate{
    func onSelectRadioButton(sender: LTHRadioButton) {
        let cell = sender.superview?.superview as! CustomTableViewCell
        let tableview = cell.superview as! UITableView
        let selectedRowIndex = tableview.indexPath(for: cell)!.row
        
        presenter.onSelectRadioButton(sectionTag: checkTableView(tableview), itemIndex: selectedRowIndex)
    }
}
