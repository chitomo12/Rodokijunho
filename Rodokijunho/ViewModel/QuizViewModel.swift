//
//  QuizViewModel.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/14.
//

import Foundation
import FirebaseFirestore

struct ArrayForSortViewModel {
    var quizNumber: Int
    var quizArrayRowString: String
    var answeredCorrectly: Int
}

class QuizViewModel {
    
    // CSVから整形した配列を格納
    var csvArray: [String] = []
    // csvArrayを元に、問題ごとに配列を作り格納
    var quizArray: [String] = []
    // 現在の問題番号をカウントするための変数（CSV内の問題番号とは独立）
    var count: Int 
    // 正解数をカウント
    var correctCount = 0
    // 一回のプレイの出題数
    let totalQuizNumberForOneGame = 10
    
    let db = Firestore.firestore()
    var numberOfCorrectAnswer: Int = 0
    var numberOfIncorrectAnswer: Int = 0
    
    init(){
        count = 1
        csvArray = self.loadCSV(fileName: "quiz1")
        quizArray = csvArray[count - 1].components(separatedBy: ",")
        // Firestoreから正答回答数、不正答回答数を取得する
        (numberOfCorrectAnswer, numberOfIncorrectAnswer) = getAnswerRecord(quizNumber: Int(quizArray[0])!)
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
            var arrayForSort: [ArrayForSortViewModel] = []
            for i in 1...csvArray.count {
                arrayForSort.append(ArrayForSortViewModel(quizNumber: i,
                                                 quizArrayRowString: csvArray[i-1],
                                                 answeredCorrectly: UserDefaults.standard.bool(forKey: "q\(i)_answeredCorrectly") ? 1 : 0))
            }
            arrayForSort.shuffle()
            arrayForSort.sort(by: {$0.answeredCorrectly < $1.answeredCorrectly})
            for i in 0..<csvArray.count {
                csvArray[i] = arrayForSort[i].quizArrayRowString
            }
            
        } catch {
            print("エラー: check the 'func loadCSV(fileName: String) -> [String] ~'")
        }
        return csvArray
    }
    
    // Firestoreから統計数値を取得する関数
    func getAnswerRecord(quizNumber: Int) -> (Int, Int) {
        print("QuizViewModel.getAnswerRecordを呼び出し")
        db.collection("test").document("records").getDocument { docSnapshot, err in
            if let error = err {
                print("エラー：\(error)")
            } else {
                if docSnapshot!.get("q\(quizNumber)_answeredCorrectly") != nil {
                    self.numberOfCorrectAnswer = docSnapshot!.get("q\(quizNumber)_answeredCorrectly") as! Int
                    print("Q.\(quizNumber)のself.numberOfCorrectAnswer: \(self.numberOfCorrectAnswer)")
                } else {
                    print("docSnapshot!.get(\"q\(quizNumber)_answeredCorrectly\")がnilです")
                }
                if docSnapshot!.get("q\(quizNumber)_answeredIncorrectly") != nil {
                    self.numberOfIncorrectAnswer = docSnapshot!.get("q\(quizNumber)_answeredIncorrectly") as! Int
                    print("Q.\(quizNumber)のself.numberOfIncorrectAnswer: \(self.numberOfIncorrectAnswer)")
                } else {
                    print("docSnapshot!.get(\"q\(quizNumber)_answeredIncorrectly\")がnilです")
                }
            }
        }
        return (self.numberOfCorrectAnswer, self.numberOfIncorrectAnswer)
    }
    
    // Firestoreの回答数データを更新
    func updateStatisticRecord(quizNumber: String, result: String) {
        if result == "answeredCorrectly" {
            db.collection("test").document("records").setData([
                "q\(quizNumber)_\(result)" : self.numberOfCorrectAnswer + 1
            ], merge: true)
            print("update q\(quizNumber)_\(result) to: \(self.numberOfCorrectAnswer + 1)")
        } else if result == "answeredIncorrectly" {
            db.collection("test").document("records").setData([
                "q\(quizNumber)_\(result)" : self.numberOfIncorrectAnswer + 1
            ], merge: true)
            print("update q\(quizNumber)_\(result) to: \(self.numberOfIncorrectAnswer + 1)")
        }
    }
}
