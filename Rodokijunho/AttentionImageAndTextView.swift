//
//  AttentionImageAndTextView.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width

// 左右にアニメーションするAttention用のビュー
class AttentionImageAndTextView: UIView{
    
    let imageWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
//        drawAttentionImageAndText(x: 0, y: 0)
//        drawAttentionImageAndText(x: 160, y: 0)
//        drawAttentionImageAndText(x: 320, y: 0)
//        drawAttentionImageAndText(x: 480, y: 0)
        drawAttentionImageAndText(x: 0, y: 0)
        drawAttentionImageAndText(x: screenWidth * 1 / 4, y: 0)
        drawAttentionImageAndText(x: screenWidth * 2 / 4, y: 0)
        drawAttentionImageAndText(x: screenWidth * 3 / 4, y: 0)
        drawAttentionImageAndText(x: screenWidth * 4 / 4, y: 0)
        drawAttentionImageAndText(x: screenWidth * 5 / 4, y: 0)
    }
    
    func drawAttentionImageAndText(x: CGFloat, y: CGFloat) {
        UIImage(named: "attention_svg")?.withTintColor(.red).draw(in: CGRect(x: x, y: y, width: screenWidth / 20, height: screenWidth / 20))
        "ATTENTION".draw(at: CGPoint(x: x + (screenWidth / 20), y: y + (screenWidth / 100) ), withAttributes: [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: screenWidth / 30),
        ])
    }
}
