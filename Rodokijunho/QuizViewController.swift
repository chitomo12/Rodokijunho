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
    
    @IBOutlet weak var quizNumber: UILabel!
    @IBOutlet weak var quizText: UITextView!
    @IBOutlet var answerButton1: UIButton!
    @IBOutlet var answerButton2: UIButton!
    
    @IBAction func answerButtonAction(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == Int(quizArray[2]) {
            print("正解")
            
        } else {
            print("不正解")
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.quizNumber.frame.origin.x += 0.01
        }, completion: { _ in
            self.nextQuiz()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        csvArray = loadCSV(fileName: "quiz1")
        quizArray = csvArray[count].components(separatedBy: ",")
        quizNumber.text = "第\(String(count))問"
        quizText.text = quizArray[1]
        answerButton1.setTitle(quizArray[3], for: .normal)
        answerButton2.setTitle(quizArray[4], for: .normal)
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        print("UserDefaults.standard.bool(forKey: \"isLoggedIn\"): \(UserDefaults.standard.bool(forKey: "isLoggedIn"))")
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
            // XCodeの仕様上、csvをエディタで編集すると最後に余分な行ができるので削除する
            csvArray = csvArray.filter{ !$0.isEmpty }
        } catch {
            print("エラー")
        }
        return csvArray
    }
    
    // 次の問題に進む
    func nextQuiz(){
        if count < csvArray.count - 1 {
            count += 1
            quizArray = csvArray[count].components(separatedBy: ",")
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.quizNumber.center.x -= 100
                self.quizNumber.layer.opacity = 0.0
            }, completion: { _ in
//                // ビューのテキストを更新
                self.quizNumber.text = "第\(String(self.count))問"
                self.quizText.text = self.quizArray[1]
                self.answerButton1.setTitle(self.quizArray[3], for: .normal)
                self.answerButton2.setTitle(self.quizArray[4], for: .normal)
                self.quizNumber.center.x += 200
                // アニメーション付きでテキストを再表示
                UIView.animate(withDuration: 0.3, delay: 0.5, options: [.curveEaseInOut], animations: {
                    self.quizNumber.layer.opacity = 1.0
                    self.quizNumber.center.x -= 100
                }, completion: nil )
            })
        } else if count == csvArray.count - 1 {
            // 結果画面に遷移
            print("結果画面に遷移します")
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
