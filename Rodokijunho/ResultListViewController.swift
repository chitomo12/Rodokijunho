//
//  CustomTableViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit
import Firebase
//import RxSwift
//import RxCocoa

// 成績一覧画面
class ResultListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var seikaisuLabel: UILabel!
    @IBOutlet weak var numberOfSolvedLabel: UILabel!
    
    var csvArray: [String] = []
    var quizNumber: Int = 0
    var solvedNumber: Int = 0
    
    var correctlyAnsweredRateDictionary: [String: Int] = ["key": 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        csvArray = loadCSVArray(fileName: "quiz1")
        
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // graphViewにグラフを描画
        let circleGraphView = CircleGraphView(frame: graphView.bounds)
        circleGraphView.backgroundColor = UIColor.white
        graphView.addSubview(circleGraphView)
        
        // graphViewに正解数を表示
        quizNumber = csvArray.count
        solvedNumber = 0
        for i in 1...quizNumber {
            if UserDefaults.standard.bool(forKey: "q\(i)_answeredCorrectly") == true {
                solvedNumber += 1
            }
        }
        self.numberOfSolvedLabel.text = "\(solvedNumber)/\(quizNumber)問"
        graphView.addSubview(numberOfSolvedLabel)
        graphView.addSubview(seikaisuLabel)
        
        createCircle()
        
        // Firebaseの処理
        let db = Firestore.firestore()
        db.collection("test").document("records").getDocument { [weak self] docSnapshot, err in
            if err == nil {
                // 正答率を個別セル用のプロパティに格納する
                for i in 1...self!.quizNumber {
                    if docSnapshot?.get("q\(i)_answeredCorrectly") != nil
                        && docSnapshot?.get("q\(i)_answeredIncorrectly") != nil {
                        self!.correctlyAnsweredRateDictionary["q\(i)"] = Int(round((docSnapshot?.get("q\(i)_answeredCorrectly") as! Float) * 100 / ((docSnapshot?.get("q\(i)_answeredCorrectly") as! Float) + (docSnapshot?.get("q\(i)_answeredIncorrectly") as! Float))))
                    } else if docSnapshot?.get("q\(i)_answeredCorrectly") != nil && docSnapshot?.get("q\(i)_answeredIncorrectly") == nil {
                        // 正解回答数が1以上かつ不正解回答数がゼロ=nilの場合は正答率を100%にする
                        self!.correctlyAnsweredRateDictionary["q\(i)"] = 100
                    } else {
                        // 正解回答数がゼロ=nilの場合は正答率を0%にする
                        self!.correctlyAnsweredRateDictionary["q\(i)"] = 0
                    }
                    // データを個別セル用のプロパティに格納したら随時セルを更新
                    self!.tableView.reloadRows(at: [IndexPath(row: i - 1, section: 0)], with: .fade)
                }
            }
        }
    }
    
    // 円グラフのアニメーション描画
    func createCircle() {
        let path = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                radius: 50, startAngle: CGFloat(Double.pi) * (-0.5),
                                endAngle: CGFloat(Double.pi) * (2.0 * ( CGFloat(solvedNumber) / CGFloat(quizNumber) ) - 0.5),
                                clockwise: true)
        UIColor.clear.setFill()
        
        let lineLayer = CAShapeLayer()
        lineLayer.fillColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0)
        lineLayer.strokeColor = CGColor(red:0.6,green:0.9,blue:0.4,alpha:1.0)
        lineLayer.lineWidth = 15
        lineLayer.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        
        lineLayer.add(animation, forKey: nil)
        graphView.backgroundColor = .gray
        graphView.layer.addSublayer(lineLayer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("viewDidDisappear")
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
        // tableViewの各セルに表示するデータを生成し、渡す
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        // var correctlyAnsweredRate = 0
        cell.settingContents(indexPath: indexPath,
                             csvArray: csvArray,
                             statisticData: correctlyAnsweredRateDictionary["q\(indexPath.row + 1)"] ?? 0)

        return cell
    }
    
    
    // 未完成
    func returnCorrectlyAnsweredRate(quizNumber: Int) -> Int {
        let rate = 50
        return rate
    }
    
    var selectedCellNumber: Int = 0
    // セグエ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellNumber = indexPath.row
        print("selectedCellNumber: \(selectedCellNumber)")
        performSegue(withIdentifier: "toDetailViewSegue", sender: nil)
    }
    
    var quizArray: [String] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewSegue" {
            quizArray = csvArray[selectedCellNumber].components(separatedBy: ",")
            let nextView = segue.destination as! ResultDetailViewController
            nextView.quizArray = quizArray
        }
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
    }
}

