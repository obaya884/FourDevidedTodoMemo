//
//  ViewController.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/04/28.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit
import LTHRadioButton
import PopupDialog

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Initialization
    
    //アウトレット変数
    @IBOutlet var topLeftSectionNameLabel: UILabel!
    @IBOutlet var topRightSectionNameLabel: UILabel!
    @IBOutlet var bottomLeftSectionNameLabel: UILabel!
    @IBOutlet var bottomRightSectionNameLabel: UILabel!
    
    @IBOutlet var topLeftSectionTableView: UITableView!
    @IBOutlet var topRightSectionTableView: UITableView!
    @IBOutlet var bottomLeftSectionTableView: UITableView!
    @IBOutlet var bottomRightSectionTableView: UITableView!
    
    //変数
    // モーダルビューのインスタンス
    let modalView = ModalViewController(nibName: "ModalViewController", bundle: nil)
    
    var tag: Int = 0
    var dataArrays: [[String]] = []
    
    var topLeftSectionTestArray: [String]! = ["夕食の買い物", "日用品の買い物", "部屋掃除", "洗車", "テレビ買い替え", "犬の散歩"]
    var topRightSectionTestArray: [String]! = ["書類整理", "会議資料作成", "上司打ち合わせ", "週報作成", "引き継ぎ用意", "データ提出"]
    var bottomLeftSectionTestArray: [String]! = ["プログラミング", "ブログ執筆", "読書", "筋トレ"]
    var bottomRightSectionTestArray: [String]! = ["録画の消化", "ゲームプレイ", "チケット申し込み", "写真整理", "レタッチ"]
    
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //delegateとdatasourceの設定
        topLeftSectionTableView.dataSource = self
        topLeftSectionTableView.delegate = self
        topRightSectionTableView.dataSource = self
        topRightSectionTableView.delegate = self
        bottomLeftSectionTableView.dataSource = self
        bottomLeftSectionTableView.delegate = self
        bottomRightSectionTableView.dataSource = self
        bottomRightSectionTableView.delegate = self
        
        //カスタムセルの登録
        self.topLeftSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.topRightSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.bottomLeftSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.bottomRightSectionTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        //データ配列作成
        generateDataArrays()
        
        //ModalViewのdelegate
        modalView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.topLeftSectionTableView.flashScrollIndicators()
        self.topRightSectionTableView.flashScrollIndicators()
        self.bottomLeftSectionTableView.flashScrollIndicators()
        self.bottomRightSectionTableView.flashScrollIndicators()
        
    }
    
    //タスク追加ボタン押下時のメソッド(PopupDialogを用いたモーダル表示）
    @IBAction func pushPlusButton(){
        
        //モーダル外のオーバーレイ表示の設定
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color           = .white
        overlayAppearance.blurRadius      = 5
        overlayAppearance.blurEnabled     = true
        overlayAppearance.liveBlurEnabled = false
        overlayAppearance.opacity         = 0.2
        
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: modalView, transitionStyle: .zoomIn)
        
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
    }
    
    //データ配列の作成メソッド
    func generateDataArrays(){
        dataArrays.removeAll()
        dataArrays.append(topLeftSectionTestArray)
        dataArrays.append(topRightSectionTestArray)
        dataArrays.append(bottomLeftSectionTestArray)
        dataArrays.append(bottomRightSectionTestArray)
        
    }
    
    
    // MARK:- TableView
    // tableviewの処理を分岐するメソッド
    func checkTableView(_ tableView: UITableView) -> Void{
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkTableView(tableView)
        return dataArrays[tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkTableView(tableView)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        //テキスト反映
        cell.taskLabel.text = dataArrays[tag][indexPath.row]
        
        //cell選択時のハイライト解除
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //cellのdelegate実装先の設定
        cell.delegate = self
        
        return cell
    }
    
    
}

extension ViewController: RadioButtonDelegate{
    func onSelectRadioButton(sender: LTHRadioButton) {
        print("catch delegate")
        let cell = sender.superview?.superview as? CustomTableViewCell
        let tableview = cell?.superview as? UITableView
        
        if( (tableview?.isEqual(topLeftSectionTableView))! ){
            
            let indexPath = self.topLeftSectionTableView.indexPath(for: cell!)
            
            //1次元データの削除
            self.topLeftSectionTestArray.remove(at: indexPath!.row)
            print(topLeftSectionTestArray)
            
            //2次元データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateDataArrays()
            
            //tableviewの操作
            self.topLeftSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.topLeftSectionTableView.reloadData()
            }
            
        }
        else if( (tableview?.isEqual(topRightSectionTableView))! ){
            let indexPath = self.topRightSectionTableView.indexPath(for: cell!)
            
            //1次元データの削除
            self.topRightSectionTestArray.remove(at: indexPath!.row)
            print(topRightSectionTestArray)
            
            //2次元データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateDataArrays()
            
            //tableviewの操作
            self.topRightSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.topRightSectionTableView.reloadData()
            }
        }
        else if( (tableview?.isEqual(bottomLeftSectionTableView))! ){
            let indexPath = self.bottomLeftSectionTableView.indexPath(for: cell!)
            
            //1次元データの削除
            self.bottomLeftSectionTestArray.remove(at: indexPath!.row)
            print(bottomLeftSectionTestArray)
            
            //2次元データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateDataArrays()
            
            //tableviewの操作
            self.bottomLeftSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.bottomLeftSectionTableView.reloadData()
            }
        }
        else if( (tableview?.isEqual(bottomRightSectionTableView))! ){
            let indexPath = self.bottomRightSectionTableView.indexPath(for: cell!)
            
            //1次元データの削除
            self.bottomRightSectionTestArray.remove(at: indexPath!.row)
            print(bottomRightSectionTestArray)
            
            //2次元データ再生成
            //numberOfRowsInSectionではここを見てるから
            //作り直さないとdeleteRowsでnumberOfRowsInSection呼ぶ時に数が変わってなくて死ぬ
            generateDataArrays()
            
            //tableviewの操作
            self.bottomRightSectionTableView.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.bottomRightSectionTableView.reloadData()
            }
        }
    }
}

extension ViewController: AddButtonDelegate{
    func afterPushModalViewAddButton(sectionTag: Int, content: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            print("catch delegate")
            print(sectionTag, content)
            
            switch sectionTag {
            case 0:
                self.topLeftSectionTestArray.insert(content, at: 0)
                self.generateDataArrays()
                self.topLeftSectionTableView.beginUpdates()
                self.topLeftSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.topLeftSectionTableView.endUpdates()
                self.topLeftSectionTableView.flashScrollIndicators()
                
                
            case 1:
                self.topRightSectionTestArray.insert(content, at: 0)
                self.generateDataArrays()
                self.topRightSectionTableView.beginUpdates()
                self.topRightSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.topRightSectionTableView.endUpdates()
                self.topRightSectionTableView.flashScrollIndicators()

                
            case 2:
                self.bottomLeftSectionTestArray.insert(content, at: 0)
                self.generateDataArrays()
                self.bottomLeftSectionTableView.beginUpdates()
                self.bottomLeftSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.bottomLeftSectionTableView.endUpdates()
                self.bottomLeftSectionTableView.flashScrollIndicators()
                
            case 3:
                self.bottomRightSectionTestArray.insert(content, at: 0)
                self.generateDataArrays()
                self.bottomRightSectionTableView.beginUpdates()
                self.bottomRightSectionTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.bottomRightSectionTableView.endUpdates()
                self.bottomRightSectionTableView.flashScrollIndicators()
                
            default:
                break
            }
        }
    }
}
