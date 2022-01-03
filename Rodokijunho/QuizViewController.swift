//
//  QuizViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit
import Firebase

class QuizViewController: UIViewController {
    
    // CSVから整形した配列を格納
    var csvArray: [String] = []
    // csvArrayを元に、問題ごとに配列を作り格納
    var quizArray: [String] = []
    // 現在の問題番号をカウントするための変数（CSV内の問題番号とは独立）
    var count = 1
    // 正解数をカウント
    var correctCount = 0
    // 一回のプレイの出題数
    var totalQuizNumberForOneGame = 3
    
    @IBOutlet weak var currentNumberInAll: UILabel!
    @IBOutlet weak var quizNumber: UILabel!
    @IBOutlet weak var quizText: UITextView!
    @IBOutlet weak var quizNumberAndText: UIView!
    @IBOutlet var answerButton1: UIButton!
    @IBOutlet var answerButton2: UIButton!
    
    @IBOutlet weak var judgeView: UIView!
    @IBOutlet weak var judgeImage: UIImageView!
    @IBOutlet weak var judgeText: UILabel!
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var explainText: UITextView!
    
    @IBOutlet weak var toNextQuizButton: UIButton!
    
    let db = Firestore.firestore()
    var numberOfCorrectAnswer: Int = 0
    var numberOfIncorrectAnswer: Int = 0
    
    @IBAction func toNextQuizButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.answerButton1.layer.opacity = 0.0
            self.answerButton2.layer.opacity = 0.0
            self.judgeView.layer.opacity = 0
            self.quizNumberAndText.center.x += 0.01
        }, completion: { _ in
            self.nextQuiz()
        })
    }
    
    // button
    let buttonTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 22),
        .foregroundColor: UIColor.white,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        csvArray = loadCSV(fileName: "quiz1")
        // csvを読み込み後、正答しなかった問題を前に持ってくる
        
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
        
        // Firestoreから回答数を取得する
        (self.numberOfCorrectAnswer, self.numberOfIncorrectAnswer) = getAnswerRecord(quizNumber: Int(quizArray[0])!)
        
        self.currentNumberInAll.text = "1 ／ \(totalQuizNumberForOneGame)"
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
            // Firestoreのデータを更新
            db.collection("test").document("records").setData([
                "q\(quizArray[0])_answeredCorrectly" : self.numberOfCorrectAnswer + 1
            ], merge: true)
        } else {
            print("不正解")
            UserDefaults.standard.set(false, forKey: "q\(quizArray[0])_answeredCorrectly")
            self.judgeImage.image = UIImage(systemName: "xmark")
            self.judgeText.text = "不正解！"
            // Firestoreのデータを更新
            db.collection("test").document("records").setData([
                "q\(quizArray[0])_answeredIncorrectly" : self.numberOfIncorrectAnswer + 1
            ], merge: true)
        }
        self.correctAnswer.text = "正解は「\(quizArray[ Int(quizArray[2])! + 2 ])」"
        self.explainText.text = quizArray[6]
        
        // 最後の問題の場合、「次の問題へ」を「結果画面へ」に変える
        if count >= totalQuizNumberForOneGame {
            let nextButtonTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor: UIColor(named:"mainColor")!,
            ]
            self.toNextQuizButton.setAttributedTitle(NSAttributedString(string: "結果画面へ", attributes: nextButtonTextAttributes),
                                                     for: .normal)
        }
        
        // アニメーション付きで判定Viewを表示する
        self.judgeImage.frame = CGRect(x: 40, y: 40, width: 1, height: 1)
        self.judgeView.layer.opacity = 1
        self.judgeView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.judgeImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.judgeView.center.y += 0.01
        }, completion: nil)
    }
    
    // CSVを読み込むメソッド
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            // Stringを元に、String型のArrayを作る
            csvArray = lineChange.components(separatedBy: "\n")
            // ヘッダー行を削除する
            csvArray.removeFirst()
            // XCodeの仕様上、csvをエディタで編集すると最後に余分な行ができるので削除する
            csvArray = csvArray.filter{ !$0.isEmpty }
            // 正答しなかった問題を前に持ってくる
            var arrayForSort: [ArrayForSort] = []
            for i in 1...csvArray.count {
                arrayForSort.append(ArrayForSort(quizNumber: i,
                                                 quizArrayRowString: csvArray[i-1],
                                                 answeredCorrectly: UserDefaults.standard.bool(forKey: "q\(i)_answeredCorrectly") ? 1 : 0))
            }
            // 順番をランダムにする
            arrayForSort.shuffle()
            arrayForSort.sort(by: {$0.answeredCorrectly < $1.answeredCorrectly})
            for i in 0..<csvArray.count {
                csvArray[i] = arrayForSort[i].quizArrayRowString
            }
        } catch {
            print("Error: check the 'func loadCSV(fileName: String) -> [String] ~'")
        }
        return csvArray
    }
    
    struct ArrayForSort {
        var quizNumber: Int
        var quizArrayRowString: String
        var answeredCorrectly: Int
    }
    
    // 次の問題に進むメソッド
    func nextQuiz(){
        
        judgeView.isHidden = true
        
        if count < totalQuizNumberForOneGame {
            count += 1
            quizArray = csvArray[count - 1].components(separatedBy: ",")
            
            // Firestoreから過去の回答数記録を取得する
            (self.numberOfCorrectAnswer, self.numberOfIncorrectAnswer) = getAnswerRecord(quizNumber: Int(quizArray[0])!)
            
            // アニメーション付きで前の問題を隠す
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                self.quizNumberAndText.center.x -= 100
                self.quizNumberAndText.layer.opacity = 0.0
            }, completion: { _ in
                // ビューのテキストを更新
                self.currentNumberInAll.text = "\(self.count) ／ \(self.totalQuizNumberForOneGame)"

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
                    self.answerButton1.layer.opacity = 1.0
                    self.answerButton2.layer.opacity = 1.0
                }, completion: { _ in
//                    self.answerButton2.isHidden = false
                } )
            })
        } else if count >= totalQuizNumberForOneGame {
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
            nextView.numberOfQuiz = totalQuizNumberForOneGame
        }
    }
    
    func getAnswerRecord(quizNumber: Int) -> (Int, Int) {
        db.collection("test").document("records").getDocument { docSnapshot, err in
            if let error = err {
                print("エラー：\(error)")
            } else {
                if docSnapshot!.get("q\(quizNumber)_answeredCorrectly") != nil {
                    self.numberOfCorrectAnswer = docSnapshot!.get("q\(quizNumber)_answeredCorrectly") as! Int
                    print("self.numberOfCorrectAnswer: \(self.numberOfCorrectAnswer)")
                } else {
                    print("docSnapshot!.get(\"q\(quizNumber)_answeredCorrectly\")がnilです")
                }
                if docSnapshot!.get("q\(quizNumber)_answeredIncorrectly") != nil {
                    self.numberOfIncorrectAnswer = docSnapshot!.get("q\(quizNumber)_answeredIncorrectly") as! Int
                    print("self.numberOfCorrectAnswer: \(self.numberOfIncorrectAnswer)")
                } else {
                    print("docSnapshot!.get(\"q\(quizNumber)_answeredIncorrectly\")がnilです")
                }
            }
        }
        return (self.numberOfCorrectAnswer, self.numberOfIncorrectAnswer)
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
