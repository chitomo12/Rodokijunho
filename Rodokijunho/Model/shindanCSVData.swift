//
//  shindanCSVData.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/13.
//

import Foundation

class ShindanCSVData {
    
    var csvArray: [String] = []
    
    func loadCSVArray(fileName: String) -> [String] {
        csvArray = []
        
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
            print(csvArray)
        } catch {
            print("エラー")
        }
        return csvArray
    }
}

func loadShindanCSVArray(fileName: String) -> [String] {
    var csvArray: [String] = []
    
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
