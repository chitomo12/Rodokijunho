//
//  CustomTableViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit

class CustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
        
    var csvArray: [String] = []
    
//    var maskLayer: CAShapeLayer = CAShapeLayer()
//    let cornerRadius = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        csvArray = loadCSV(fileName: "quiz1")
        
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(
//            roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: .init(width: cornerRadius, height: cornerRadius)).cgPath
//        tableView.layer.mask = maskLayer
//        tableView.layer.masksToBounds = true
    }
    
    // 画面右上のリセットボタンの処理
    @IBAction func resetButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController.init(title: "成績データを初期化", message: "成績データを初期化します。", preferredStyle: UIAlertController.Style.alert)
        let cancelAction: UIAlertAction = UIAlertAction.init(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
             (UIAlertAction) in
            print("キャンセルしました")
        })
        alert.addAction(cancelAction)
        let resetAction: UIAlertAction = UIAlertAction.init(title: "初期化する", style: UIAlertAction.Style.destructive, handler: { (UIAlertAction) in
            print("初期化します")
        })
        alert.addAction(resetAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (csvArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        cell.settingContents(indexPath: indexPath, csvArray: csvArray)
        
        return cell
    }
    
    // CSVを読み込むメソッド
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            print("csvData: \(csvData)")
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            print("lineChange: \(lineChange)")
            // Stringを元に、String型のArrayを作る
            csvArray = lineChange.components(separatedBy: "\n")
            // ヘッダー行を削除する
            csvArray.removeFirst()
            // XCodeの仕様上、csvをエディタで編集すると最後に余分な行ができるので削除する
            csvArray = csvArray.filter{ !$0.isEmpty }
        } catch {
            print("エラー")
        }
        return csvArray
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
