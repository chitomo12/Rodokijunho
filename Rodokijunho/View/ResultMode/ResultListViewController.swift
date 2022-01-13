//
//  CustomTableViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit
import Firebase

// 成績一覧画面
class ResultListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var seikaisuLabel: UILabel!
    @IBOutlet weak var numberOfSolvedLabel: UILabel!
    
//    var csvArray: [String] = []
//    var quizNumber: Int = 0
//    var solvedNumber: Int = 0
    
    var correctlyAnsweredRateDictionary: [String: Int] = ["key": 0]
    
    var resultListViewModel = ResultListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "QuizListTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // graphViewにグラフを描画
        let circleGraphView = CircleGraphView(frame: graphView.bounds)
        circleGraphView.backgroundColor = UIColor.white
        graphView.addSubview(circleGraphView)
        
        // graphViewに正解数を表示
        self.numberOfSolvedLabel.text = "\(resultListViewModel.solvedNumber)/\(resultListViewModel.totalNumberOfQuiz)問"
        // アニメーションする円グラフ → 上の文字 の順にSubviewを追加
        graphView.layer.addSublayer(resultListViewModel.createCircleLineLayer())
        graphView.addSubview(numberOfSolvedLabel)
        graphView.addSubview(seikaisuLabel)
        
        // Firebaseから正答率統計データを取得
        let db = Firestore.firestore()
        db.collection("test").document("records").getDocument { [weak self] docSnapshot, err in
            if err == nil {
                // 正答率を個別セル用のプロパティに格納する
                for i in 1...self!.resultListViewModel.totalNumberOfQuiz {
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
                self.resultListViewModel.resetData()
                // ViewControllerを再読み込み
                self.loadView()
                self.viewDidLoad()
            }
        )
        alert.addAction(resetAction)
        present(alert, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultListViewModel.csvArray.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tableViewの各セルに表示するデータを生成し、渡す
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! QuizListTableViewCell
        cell.settingContents(indexPath: indexPath,
                             csvArray: resultListViewModel.csvArray,
                             statisticData: correctlyAnsweredRateDictionary["q\(indexPath.row + 1)"] ?? 0)
        return cell
    }
    
    var selectedCellNumber: Int = 0
    
    // セグエ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellNumber = indexPath.row
        performSegue(withIdentifier: "toDetailViewSegue", sender: nil)
    }
    
    var quizArray: [String] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewSegue" {
            let nextView = segue.destination as! ResultDetailViewController
            nextView.quizArray = resultListViewModel.csvArray[selectedCellNumber].components(separatedBy: ",")
        }
    }

}

