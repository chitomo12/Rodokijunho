//
//  CustomTableViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit

class CircleGraphView: UIView {
    override func draw(_ rect: CGRect) {
        let circleCenter = CGPoint(x: 60, y: 60)
        let circleRadius = CGFloat(50)
        
        // 背景のグレーの円
        let backCircle = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        UIColor(red: 0.9, green:0.9,blue:0.9,alpha:0.8).setStroke()
        backCircle.lineWidth = 15
        backCircle.stroke()
        
        // csvとUserDefaultsを読み込み、正解した数からグラフを描画
        let csvArray = loadCSVArray(fileName: "quiz1")
        let quizNumber = csvArray.count
        var solvedNumber = 0
        for i in 1...quizNumber {
            if UserDefaults.standard.bool(forKey: "q\(i)_answeredCorrectly") == true {
                solvedNumber += 1
            }
        }
        
        let circle = UIBezierPath(arcCenter: circleCenter,
                                  radius: circleRadius,
                                  startAngle: CGFloat(Double.pi) * (-0.5),
                                  endAngle: CGFloat(Double.pi) * (2.0 * ( CGFloat(solvedNumber) / CGFloat(quizNumber) ) - 0.5),
                                  clockwise: true)
        UIColor(red:0.6,green:0.9,blue:0.6,alpha:1).setStroke()
        circle.lineWidth = 7
        circle.stroke()
        
//        let style = NSMutableParagraphStyle()
//        style.alignment = NSTextAlignment.center
//
//        "2問/3問\n正解".draw(at: CGPoint(x: 15, y: 40), withAttributes: [
//            .paragraphStyle: style,
//            NSAttributedString.Key.foregroundColor: UIColor.gray,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
//        ])
    }
}

// 成績一覧画面
class CustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var seikaisuLabel: UILabel!
    @IBOutlet weak var numberOfSolvedLabel: UILabel!
    
    var csvArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        csvArray = loadCSV(fileName: "quiz1")
        csvArray = loadCSVArray(fileName: "quiz1")
        
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // graphViewにグラフを描画
        let circleGraphView = CircleGraphView(frame: graphView.bounds)
        circleGraphView.backgroundColor = UIColor.white
        graphView.addSubview(circleGraphView)
        
        // graphViewに正解数を表示
        let quizNumber = csvArray.count
        var solvedNumber = 0
        for i in 1...quizNumber {
            if UserDefaults.standard.bool(forKey: "q\(i)_answeredCorrectly") == true {
                solvedNumber += 1
            }
        }
        self.numberOfSolvedLabel.text = "\(solvedNumber)/\(quizNumber)問"
        graphView.addSubview(numberOfSolvedLabel)
        graphView.addSubview(seikaisuLabel)
    }
    
    // 画面右上のリセットボタンの処理
    @IBAction func resetButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController.init(
            title: "成績データを初期化",
            message: "成績データを初期化します。",
            preferredStyle: UIAlertController.Style.alert)
        let cancelAction: UIAlertAction = UIAlertAction.init(
            title: "キャンセル",
            style: UIAlertAction.Style.cancel,
            handler: { (UIAlertAction) in
                print("キャンセルしました")
            }
        )
        alert.addAction(cancelAction)
        let resetAction: UIAlertAction = UIAlertAction.init(
            title: "初期化する",
            style: UIAlertAction.Style.destructive,
            handler: { (UIAlertAction) in
                print("初期化します")
                for i in 1...self.csvArray.count {
                    UserDefaults.standard.set(false, forKey: "q\(i)_answeredCorrectly")
                    print("q\(i)_answeredCorrectly -> false")
                }
                // ViewControllerを再読み込み
                self.loadView()
                self.viewDidLoad()
            }
        )
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
    
//    // CSVを読み込むメソッド
//    func loadCSV(fileName: String) -> [String] {
//        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
//        do {
//            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
//            print("csvData: \(csvData)")
//            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
//            print("lineChange: \(lineChange)")
//            // Stringを元に、String型のArrayを作る
//            csvArray = lineChange.components(separatedBy: "\n")
//            // ヘッダー行を削除する
//            csvArray.removeFirst()
//            // XCodeの仕様上、csvをエディタで編集すると最後に余分な行ができるので削除する
//            csvArray = csvArray.filter{ !$0.isEmpty }
//        } catch {
//            print("エラー")
//        }
//        return csvArray
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
