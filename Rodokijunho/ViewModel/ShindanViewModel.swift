//
//  ShindanModeViewModel.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/13.
//

import Foundation

class ShindanViewModel {
    var csvData: ShindanCSVData
    var shindanArrays: [[String]] = []
    var currentShindanArray: [String] = []
    var currentShindanNumber: Int = 1
    var count = 0
    
    init(){
        csvData = ShindanCSVData()
        csvData.csvArray = csvData.loadCSVArray(fileName: "shindan")
        
        for i in 0..<csvData.csvArray.count {
            let lineChange = csvData.csvArray[i].replacingOccurrences(of: "\\n", with: "\n")
            let shindanArray = lineChange.components(separatedBy: ",")
            shindanArrays.append(shindanArray)
        }
    }
    
    func addCount() {
        count += 1
    }
}
