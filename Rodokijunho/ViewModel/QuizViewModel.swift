//
//  QuizViewModel.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/14.
//

import Foundation


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
    var count = 1
    // 正解数をカウント
    var correctCount = 0
    // 一回のプレイの出題数
    var totalQuizNumberForOneGame = 10
    
    init(){
        print("QuizViewModel is instantiated.")
        csvArray = self.loadCSV(fileName: "quiz1")
        print("quizViewModel.csvArray: \(csvArray)")
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
            print("Error: check the 'func loadCSV(fileName: String) -> [String] ~'")
        }
        return csvArray
    }
}
