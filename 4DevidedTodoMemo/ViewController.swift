//
//  ViewController.swift
//  4DevidedTodoMemo
//
//  Created by 大林拓実 on 2019/04/28.
//  Copyright © 2019 TakumiObayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    //画面パーツ変数
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var topLeftSectionNameLabel: UILabel!
    @IBOutlet var topRightSectionNameLabel: UILabel!
    @IBOutlet var bottomLeftSectionNameLabel: UILabel!
    @IBOutlet var bottomRightSectionNameLabel: UILabel!
    
    @IBOutlet var topLeftSectionTableView: UITableView!
    @IBOutlet var topRightSectionTableView: UITableView!
    @IBOutlet var bottomLeftSectionTableView: UITableView!
    @IBOutlet var bottomRightSectionTableView: UITableView!
    
    var cellIdentifier: String = ""
    var tag: Int = 0
    var testArrays: [[String]] = []
    
    let topLeftSectionTestArray = ["夕食の買い物", "日用品の買い物", "部屋掃除", "洗車", "テレビ買い替え", "犬の散歩"]
    let topRightSectionTestArray = ["書類整理", "会議資料作成", "上司打ち合わせ", "週報作成", "引き継ぎ用意", "データ提出"]
    let bottomLeftSectionTestArray = ["プログラミング", "ブログ執筆", "読書", "筋トレ"]
    let bottomRightSectionTestArray = ["録画の消化", "ゲームプレイ", "チケット申し込み", "写真整理", "レタッチ"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topLeftSectionTableView.dataSource = self
        topLeftSectionTableView.delegate = self
        topRightSectionTableView.dataSource = self
        topRightSectionTableView.delegate = self
        bottomLeftSectionTableView.dataSource = self
        bottomLeftSectionTableView.delegate = self
        bottomRightSectionTableView.dataSource = self
        bottomRightSectionTableView.delegate = self
        
        testArrays.append(topLeftSectionTestArray)
        testArrays.append(topRightSectionTestArray)
        testArrays.append(bottomLeftSectionTestArray)
        testArrays.append(bottomRightSectionTestArray)
    }
    
    // 処理を分岐するメソッド
    func checkTableView(_ tableView: UITableView) -> Void{
        if (tableView.isEqual(topLeftSectionTableView)) {
            tag = 0
            cellIdentifier = "Cell"
        }
        else if (tableView.isEqual(topRightSectionTableView)) {
            tag = 1
            cellIdentifier = "Cell"
        }
        else if (tableView.isEqual(bottomLeftSectionTableView)) {
            tag = 2
            cellIdentifier = "Cell"
        }
        else if (tableView.isEqual(bottomRightSectionTableView)){
            tag = 3
            cellIdentifier = "Cell"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkTableView(tableView)
        print(testArrays[tag].count)
        return testArrays[tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkTableView(tableView)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        cell.textLabel?.text = testArrays[tag][indexPath.row]
        
        return cell
    }
    
    
    
}

