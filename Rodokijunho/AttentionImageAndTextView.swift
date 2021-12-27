//
//  AttentionImageAndTextView.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import UIKit

// 左右にアニメーションするAttention用のビュー
class AttentionImageAndTextView: UIView{
    override func draw(_ rect: CGRect) {
        drawAttentionImageAndText(x: 0, y: 0)
        drawAttentionImageAndText(x: 160, y: 0)
        drawAttentionImageAndText(x: 320, y: 0)
        drawAttentionImageAndText(x: 480, y: 0)
    }
    
    func drawAttentionImageAndText(x: CGFloat, y: CGFloat) {
        UIImage(named: "attention_svg")?.withTintColor(.red).draw(in: CGRect(x: x, y: y, width: 30, height: 30))
        "ATTENTION".draw(at: CGPoint(x: x + 32, y: y + 2), withAttributes: [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
        ])
    }
}
