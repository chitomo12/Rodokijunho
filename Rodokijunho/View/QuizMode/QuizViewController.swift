//
//  QuizViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit
import Firebase
import FirebaseFirestore

class QuizViewController: UIViewController {
    
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
    
    // 回答ボタンのテキスト属性を定義
    let buttonTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 22, weight: .bold),
        .foregroundColor: UIColor.white,
    ]
    
    var quizViewModel = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizNumber.text = "第\(String(quizViewModel.count))問"
        quizText.text = quizViewModel.quizArray[1]
        answerButton1.setAttributedTitle(NSAttributedString(string: quizViewModel.quizArray[3], attributes: buttonTextAttributes), for: .normal)
        answerButton2.setAttributedTitle(NSAttributedString(string: quizViewModel.quizArray[4], attributes: buttonTextAttributes), for: .normal)
        self.currentNumberInAll.text = "1 ／ \(quizViewModel.totalQuizNumberForOneGame)"
        self.judgeView.isHidden = true
        
        // ナビゲーションバーの色変更
        self.navigationController?.navigationBar.tintColor = UIColor(named: "mainColorDark")
    }
    
    // 回答ボタンを押した後の処理
    @IBAction func answerButtonAction(_ sender: UIButton) {
        if sender.tag == Int(quizViewModel.quizArray[2]) {
            print("正解")
            UserDefaults.standard.set(true, forKey: "q\(quizViewModel.quizArray[0])_answeredCorrectly")
            self.judgeImage.image = UIImage(systemName: "circle")?.withTintColor(UIColor(named: "mainColor")!)
            self.judgeText.text = "正解！"
            quizViewModel.correctCount += 1
            // Firestoreのデータを更新
            quizViewModel.updateStatisticRecord(quizNumber: quizViewModel.quizArray[0], result: "answeredCorrectly")
        } else {
            print("不正解")
            UserDefaults.standard.set(false, forKey: "q\(quizViewModel.quizArray[0])_answeredCorrectly")
            self.judgeImage.image = UIImage(systemName: "xmark")
            self.judgeText.text = "不正解！"
            // Firestoreのデータを更新
            quizViewModel.updateStatisticRecord(quizNumber: quizViewModel.quizArray[0], result: "answeredIncorrectly")
        }
        
        self.correctAnswer.text = "正解は「\(quizViewModel.quizArray[ Int(quizViewModel.quizArray[2])! + 2 ])」"
        self.explainText.text = quizViewModel.quizArray[6]
        
        // 最後の問題の場合、「次の問題へ」を「結果画面へ」に変える
        if quizViewModel.count >= quizViewModel.totalQuizNumberForOneGame {
            let nextButtonTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor: UIColor(named:"mainColor")!,
            ]
            self.toNextQuizButton.setAttributedTitle(NSAttributedString(string: "結果画面へ", attributes: nextButtonTextAttributes), for: .normal)
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
    
    @IBAction func toNextQuizButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.answerButton1.layer.opacity = 0.0
            self.answerButton2.layer.opacity = 0.0
            self.judgeView.layer.opacity = 0
            self.quizNumberAndText.center.x += 0.01
        }, completion: { _ in
            self.nextQuiz()
        })
    }
    
    // 次の問題に進むメソッド
    func nextQuiz(){
        judgeView.isHidden = true
        
        if quizViewModel.count < quizViewModel.totalQuizNumberForOneGame {
            quizViewModel.count += 1
            quizViewModel.quizArray = quizViewModel.csvArray[quizViewModel.count - 1].components(separatedBy: ",")
            
            // Firestoreから過去の回答数記録を取得する
            (quizViewModel.numberOfCorrectAnswer, quizViewModel.numberOfIncorrectAnswer) = quizViewModel.getAnswerRecord(quizNumber: Int(quizViewModel.quizArray[0])!)
            // アニメーション付きで前の問題を隠す
            UIView.animate(withDuration: 0.15, delay: 0.1, options: [], animations: {
                self.quizNumberAndText.center.x -= 100
                self.quizNumberAndText.layer.opacity = 0.0
            }, completion: { _ in
                // ビューのテキストを更新
                self.currentNumberInAll.text = "\(self.quizViewModel.count) ／ \(self.quizViewModel.totalQuizNumberForOneGame)"
                self.quizNumber.text = "第\(String(self.quizViewModel.count))問"
                self.quizText.text = self.quizViewModel.quizArray[1]
                self.answerButton1.setAttributedTitle(
                    NSAttributedString(string: self.quizViewModel.quizArray[3], attributes: self.buttonTextAttributes),
                    for: .normal)
                self.answerButton2.setAttributedTitle(
                    NSAttributedString(string: self.quizViewModel.quizArray[4], attributes: self.buttonTextAttributes),
                    for: .normal
                )
                
                // アニメーション付きでテキストを再表示
                self.quizNumberAndText.center.x += 200
                UIView.animate(withDuration: 0.15, delay: 0.3, options: [.curveEaseInOut], animations: {
                    self.quizNumberAndText.center.x -= 100
                    self.quizNumberAndText.layer.opacity = 1.0
                    self.answerButton1.layer.opacity = 1.0
                    self.answerButton2.layer.opacity = 1.0
                }, completion: { _ in } )
            })
        } else if quizViewModel.count >= quizViewModel.totalQuizNumberForOneGame {
            // 結果画面に遷移
            performSegue(withIdentifier: "toResultSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultSegue" {
            print("結果を表示します")
            let nextView = segue.destination as! ScoreViewController
            nextView.score = quizViewModel.correctCount
            nextView.numberOfQuiz = quizViewModel.totalQuizNumberForOneGame
        }
    }
}
