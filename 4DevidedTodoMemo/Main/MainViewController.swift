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
    
    //変数
    
    //制御用
    var tag: Int = 0
    
    //項目名用
    var itemNameDataArrays: [[String]] = []
    var topLeftSectionItemNameArray: [String] = []
    var topRightSectionItemNameArray: [String] = []
    var bottomLeftSectionItemNameArray: [String] = []
    var bottomRightSectionItemNameArray: [String] = []
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //TableViewのdelegateとdatasource設定
        topLeftSectionTableView.dataSource = self
        topLeftSectionTableView.delegate = self
        topRightSectionTableView.dataSource = self
        topRightSectionTableView.delegate = self
        bottomLeftSectionTableView.dataSource = self
        bottomLeftSectionTableView.delegate = self
        bottomRightSectionTableView.dataSource = self
        bottomRightSectionTableView.delegate = self
        
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
        //初期値を設定(ユーザーが変更してない場合はこれが取り出される)
        userDefaults.register(defaults: ["topLeftSectionName": "生活",
                                         "topRightSectionName": "仕事",
                                         "bottomLeftSectionName": "趣味",
                                         "bottomRightSectionName": "臨時"])
        //UserDefaultから値の読み出し、TextFieldに反映
        self.topLeftSectionNameTextField.text = userDefaults.object(forKey: "topLeftSectionName") as? String
        self.topRightSectionNameTextField.text = userDefaults.object(forKey: "topRightSectionName") as? String
        self.bottomLeftSectionNameTextField.text = userDefaults.object(forKey: "bottomLeftSectionName") as? String
        self.bottomRightSectionNameTextField.text = userDefaults.object(forKey: "bottomRightSectionName") as? String
        
        
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
    
    //データ配列の作成メソッド
    func generateItemNameDataArrays(){
        itemNameDataArrays.removeAll()
        itemNameDataArrays.append(topLeftSectionItemNameArray)
        itemNameDataArrays.append(topRightSectionItemNameArray)
        itemNameDataArrays.append(bottomLeftSectionItemNameArray)
        itemNameDataArrays.append(bottomRightSectionItemNameArray)
    }
    
    //画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //どのtextfield編集に対しても閉じれるようにviewに対してendEditngする
        self.view.endEditing(true)
    }
    
    // tableviewの処理を分岐するメソッド
    func checkTableView(_ tableView: UITableView) -> Int{
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

extension MainViewController: UITableViewDelegate {
    
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
        let cell = sender.superview?.superview as? CustomTableViewCell
        let tableview = cell?.superview as? UITableView
        
        //UserDefaultsのインスタンス
        let userDefaults: UserDefaults = UserDefaults.standard
        
        if( (tableview?.isEqual(topLeftSectionTableView))! ){
            
            let indexPath = self.topLeftSectionTableView.indexPath(for: cell!)
            
            //1次データの削除
            self.topLeftSectionItemNameArray.remove(at: indexPath!.row)
            
            //2次データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            
            //UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "topLeftSectionItemName")
            userDefaults.set(topLeftSectionItemNameArray, forKey: "topLeftSectionItemName")
            
            //tableviewの操作
            self.topLeftSectionTableView.beginUpdates()
            self.topLeftSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            self.topLeftSectionTableView.endUpdates()
        }
        else if( (tableview?.isEqual(topRightSectionTableView))! ){
            let indexPath = self.topRightSectionTableView.indexPath(for: cell!)
            
            //1次データの削除
            self.topRightSectionItemNameArray.remove(at: indexPath!.row)
            
            //2次データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            
            //UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "topRightSectionItemName")
            userDefaults.set(topRightSectionItemNameArray, forKey: "topRightSectionItemName")
            
            //tableviewの操作
            self.topRightSectionTableView.beginUpdates()
            self.topRightSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            self.topRightSectionTableView.endUpdates()
        }
        else if( (tableview?.isEqual(bottomLeftSectionTableView))! ){
            let indexPath = self.bottomLeftSectionTableView.indexPath(for: cell!)
            
            //1次データの削除
            self.bottomLeftSectionItemNameArray.remove(at: indexPath!.row)
            
            //2次データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            
            //UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "bottomLeftSectionItemName")
            userDefaults.set(bottomLeftSectionItemNameArray, forKey: "bottomLeftSectionItemName")
            
            //tableviewの操作
            self.bottomLeftSectionTableView.beginUpdates()
            self.bottomLeftSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            self.bottomLeftSectionTableView.endUpdates()
        }
        else if( (tableview?.isEqual(bottomRightSectionTableView))! ){
            let indexPath = self.bottomRightSectionTableView.indexPath(for: cell!)
            
            //1次データの削除
            self.bottomRightSectionItemNameArray.remove(at: indexPath!.row)
            
            //2次データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateItemNameDataArrays()
            
            //UserDefaultsの保存情報にも変更を反映
            userDefaults.removeObject(forKey: "bottomRightSectionItemName")
            userDefaults.set(bottomRightSectionItemNameArray, forKey: "bottomRightSectionItemName")
            
            //tableviewの操作
            self.bottomRightSectionTableView.beginUpdates()
            self.bottomRightSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            self.bottomRightSectionTableView.endUpdates()
        }
    }
}

