//
//  ResultDetailViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/01.
//

import UIKit

class ResultDetailViewController: UIViewController {
    
    var quizArray: [String] = []
    
    var questionNumberText: String = ""
    var questionGenreText: String = ""
    var questionTextString: String = ""
    var correctAnswerText: String = ""
    var explainLabelText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "mainColorLight")!
        
        questionNumberText = quizArray[0]
        questionGenreText = quizArray[5]
        questionTextString = quizArray[1]
        correctAnswerText = quizArray[Int(quizArray[2])! + 2]
        explainLabelText = quizArray[6]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let scrollView = UIScrollView(frame: CGRect(x: 20,
                                                    y: 20,
                                                    width: view.frame.size.width - 40,
                                                    height: view.frame.size.height - 40))
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        // labelなどを格納するcontentViewを宣言
        let contentView = UIView()
        contentView.frame = CGRect(x: 0,
                                   y: 0,
                                   width: scrollView.frame.width,
                                   height: 1200)
        
        let centerX = contentView.center.x
        
        // ---contentViewに格納する各種Viewを宣言---
        
        // 問題番号のUILabel
        let questionNumberLabel = UILabel(frame: CGRect(x: centerX - 100,
                                                        y: 120,
                                                        width: 200,
                                                        height: 40))
        questionNumberLabel.textAlignment = .center
        questionNumberLabel.text = "第\(questionNumberText)問"
        questionNumberLabel.font = UIFont.systemFont(ofSize: 40)
        contentView.addSubview(questionNumberLabel)
        
        // 問題ジャンルのUILabel
        let questionGenreLabel = UILabel(frame: CGRect(x: centerX - 100,
                                                       y: questionNumberLabel.frame.maxY + 30,
                                                       width: 200, height: 40))
        questionGenreLabel.textAlignment = .center
        questionGenreLabel.text = questionGenreText
        questionGenreLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        questionGenreLabel.textColor = .gray
        contentView.addSubview(questionGenreLabel)
        
        // 問題文のUILabel
        let questionText = UILabel()
        questionText.frame.size.width = 300
        questionText.numberOfLines = 0
        questionText.textAlignment = .justified
        questionText.text = questionTextString
        questionText.font = UIFont.systemFont(ofSize: 18)
        questionText.sizeToFit()
        questionText.frame = CGRect(x: centerX - (questionText.frame.size.width / 2),
                                    y: questionGenreLabel.frame.maxY + 30,
                                    width: questionText.frame.size.width,
                                    height: questionText.frame.size.height)
        contentView.addSubview(questionText)
        
        // 背景色のUIView（色のみ廃止）
        let backBlockView = UIView(frame: CGRect(x: centerX - 110,
                                                 y: questionText.frame.maxY + 100,
                                                 width: 220, height: 100))
//        backGreenView.backgroundColor = UIColor(named: "mainColorLight")
//        contentView.addSubview(backGreenView)
        
        // 「正解」のUILabel
        let seikaiTextLabel = UILabel(frame: CGRect(x: centerX - 100,
                                                    y: backBlockView.frame.minY + 20,
                                                    width: 200, height: 30))
        seikaiTextLabel.text = "正解"
        seikaiTextLabel.textColor = .gray
        seikaiTextLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        seikaiTextLabel.textAlignment = .center
        contentView.addSubview(seikaiTextLabel)
        
        // 正しい選択肢のUILabel
        let correctAnswerTextLabel = UILabel(frame: CGRect(x: centerX - 100,
                                                           y: seikaiTextLabel.frame.maxY + 25,
                                                           width: 200, height: 30))
        correctAnswerTextLabel.text = correctAnswerText
        correctAnswerTextLabel.textAlignment = .center
        contentView.addSubview(correctAnswerTextLabel)
        
        // 「解説」のUILabel
        let kaisetsuLabel = UILabel(frame: CGRect(x: centerX - 100,
                                                  y: correctAnswerTextLabel.frame.maxY + 50,
                                                  width: 200, height: 30))
        kaisetsuLabel.text = "解説"
        kaisetsuLabel.textColor = .gray
        kaisetsuLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        kaisetsuLabel.textAlignment = .center
        contentView.addSubview(kaisetsuLabel)
        
        // 解説文のUILabel
        let explainLabel = UILabel()
        explainLabel.frame.size.width = 300  // 改行させるためにframe幅を固定
        explainLabel.numberOfLines = 0
        explainLabel.textAlignment = .justified
        explainLabel.text = explainLabelText
        explainLabel.sizeToFit() // frameサイズをテキストに合わせる
        explainLabel.frame = CGRect(x: centerX - (explainLabel.frame.size.width / 2),
                             y: kaisetsuLabel.frame.maxY + 25,
                             width: explainLabel.frame.size.width,
                             height: explainLabel.frame.size.height)
        contentView.addSubview(explainLabel)
        
        // explainLabelの高さに合わせて背景色のサイズを変更
        backBlockView.frame = CGRect(x: centerX - 170,
                                     y: backBlockView.frame.minY,
                                     width: 340,
                                     height: explainLabel.frame.maxY - backBlockView.frame.minY + 20)
        
        // 下位ビューの高さに合わせてcontentViewのframeサイズを更新
        contentView.frame = CGRect(x: 0,
                                   y: 0,
                                   width: scrollView.frame.width,
                                   height: explainLabel.frame.maxY + 50)
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 50
    }

}
