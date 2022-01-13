//
//  CircleGraphView.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/12.
//

import Foundation
import UIKit

class CircleGraphView: UIView {
    override func draw(_ rect: CGRect) {
        let circleCenter = CGPoint(x: 60, y: 60)
        let circleRadius = CGFloat(50)
        
        // 背景のグレーの円
        let backCircle = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        UIColor(red: 0.9, green:0.9,blue:0.9,alpha:0.8).setStroke()
        backCircle.lineWidth = 15
        backCircle.stroke()
    }
}

