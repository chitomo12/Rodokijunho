//
//  QuizViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit

class QuizViewController: UIViewController {
    
    // CSVから整形した配列を格納
    var csvArray: [String] = []
    // csvArrayを元に、問題ごとに配列を作り格納
    var quizArray: [String] = []
    // 現在の問題番号をカウントするための変数（CSV内の問題番号とは独立）
    var count = 1
    // 正解数をカウント
    var correctCount = 0
    
    @IBOutlet weak var quizNumber: UILabel!
    @IBOutlet weak var quizText: UITextView!
    @IBOutlet weak var quizNumberAndText: UIView!
    @IBOutlet var answerButton1: UIButton!
    @IBOutlet var answerButton2: UIButton!
    
    @IBOutlet weak var judgeView: UIView!
    @IBOutlet weak var judgeImage: UIImageView!
    @IBOutlet weak var explainText: UITextView!
    
    @IBOutlet weak var toNextQuizButton: UIButton!
    @IBAction func toNextQuizButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.quizNumberAndText.center.x += 0.01
        }, completion: { _ in
            self.nextQuiz()
        })
    }
    @IBOutlet weak var judgeText: UILabel!
    
    // button
    let buttonTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 22),
        .foregroundColor: UIColor.white,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        csvArray = loadCSV(fileName: "quiz1")
        quizArray = csvArray[count - 1].components(separatedBy: ",")
        quizNumber.text = "第\(String(count))問"
        quizText.text = quizArray[1]
        answerButton1.setAttributedTitle(
            NSAttributedString(string: quizArray[3],
                               attributes: buttonTextAttributes),
            for: .normal
        )
        answerButton2.setAttributedTitle(
            NSAttributedString(string: quizArray[4],
                               attributes: buttonTextAttributes),
            for: .normal
        )
        self.judgeView.isHidden = true
    }
    
    // 回答ボタンを押した後の処理
    @IBAction func answerButtonAction(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == Int(quizArray[2]) {
            print("正解")
            UserDefaults.standard.set(true, forKey: "q\(quizArray[0])_answeredCorrectly")
            self.judgeImage.image = UIImage(systemName: "circle")?.withTintColor(UIColor(named: "mainColor")!)
            self.judgeText.text = "正解！"
            self.correctCount += 1
        } else {
            print("不正解")
            UserDefaults.standard.set(false, forKey: "q\(quizArray[0])_answeredCorrectly")
            self.judgeImage.image = UIImage(systemName: "xmark")
            self.judgeText.text = "不正解！"
        }
        
        self.explainText.text = quizArray[6]
        
        // 最後の問題の場合、「次の問題へ」を「結果画面へ」に変える
        if count >= csvArray.count {
            let nextButtonTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor: UIColor(named:"mainColor"),
            ]
            self.toNextQuizButton.setAttributedTitle(NSAttributedString(string: "結果画面へ", attributes: nextButtonTextAttributes),
                                                     for: .normal)
        }
        // 判定Viewを表示する
        self.judgeImage.frame = CGRect(x: 40, y: 40, width: 1, height: 1)
        self.judgeView.isHidden = false
//        UIView.animate(withDuration: 0.2,
//                       animations: {
//            self.judgeImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        })
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.judgeImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        }, completion: nil)
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
            // 順番をランダムにする
            csvArray.shuffle()
            // XCodeの仕様上、csvをエディタで編集すると最後に余分な行ができるので削除する
            csvArray = csvArray.filter{ !$0.isEmpty }
        } catch {
            print("エラー")
        }
        return csvArray
    }
    
    // 次の問題に進む
    func nextQuiz(){
        
        judgeView.isHidden = true
        
        if count < csvArray.count {
            count += 1
            quizArray = csvArray[count - 1].components(separatedBy: ",")
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                self.quizNumberAndText.center.x -= 100
                self.quizNumberAndText.layer.opacity = 0.0
            }, completion: { _ in
                // ビューのテキストを更新
                self.quizNumber.text = "第\(String(self.count))問"
                self.quizText.text = self.quizArray[1]
                
                self.answerButton1.setAttributedTitle(
                    NSAttributedString(string: self.quizArray[3],
                                       attributes: self.buttonTextAttributes),
                    for: .normal
                )
                self.answerButton2.setAttributedTitle(
                    NSAttributedString(string: self.quizArray[4],
                                       attributes: self.buttonTextAttributes),
                    for: .normal
                )
                
                self.quizNumberAndText.center.x += 200
                // アニメーション付きでテキストを再表示
                UIView.animate(withDuration: 0.3, delay: 0.5, options: [.curveEaseInOut], animations: {
                    self.quizNumberAndText.center.x -= 100
                    self.quizNumberAndText.layer.opacity = 1.0
                }, completion: nil )
            })
        } else if count >= csvArray.count {
            // 結果画面に遷移
            print("結果画面に遷移します")
            performSegue(withIdentifier: "toResultSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultSegue" {
            print("結果を表示します")
            let nextView = segue.destination as! ScoreViewController
            nextView.score = correctCount
            nextView.numberOfQuiz = csvArray.count
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
