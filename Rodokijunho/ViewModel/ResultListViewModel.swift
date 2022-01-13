//
//  ResultListViewModel.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/12.
//

import Foundation
import UIKit

class ResultListViewModel {
    
    var quizArray: [String] = []
    var csvData = CsvData()
    var csvArray: [String] = []  // CSVから取得した問題一覧
    var totalNumberOfQuiz = 0  // 全問題数
    var solvedNumber = 0  // 正答した問題数
    var correctlyAnsweredRate: CGFloat = 0.0  // 正答率
    
    init(){
        csvArray = csvData.loadCSVArray(fileName: "quiz1")
        
        totalNumberOfQuiz = csvArray.count
        for i in 1...csvArray.count {
            if UserDefaults.standard.bool(forKey: "q\(i)_answeredCorrectly") == true {
                solvedNumber += 1
            }
        }
        correctlyAnsweredRate = CGFloat(solvedNumber) / CGFloat(totalNumberOfQuiz)
    }
    
    // クイズモードの成績をリセット
    func resetData() {
        for i in 1...totalNumberOfQuiz {
            UserDefaults.standard.set(false, forKey: "q\(i)_answeredCorrectly")
            solvedNumber = 0
            correctlyAnsweredRate = 0.0
        }
    }
    
    // 円グラフのアニメーション描画
    func createCircleLineLayer() -> (CAShapeLayer) {
        let path = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                                radius: 50, startAngle: CGFloat(Double.pi) * (-0.5),
                                endAngle: CGFloat(Double.pi) * (2.0 * correctlyAnsweredRate - 0.5),
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
        return lineLayer
    }
}
