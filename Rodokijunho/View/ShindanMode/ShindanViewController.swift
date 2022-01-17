//
//  QOneViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/26.
//

import UIKit
import AVFoundation

class ShindanViewController: UIViewController {

    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    
    var shindanViewModel = ShindanViewModel()
    
    // 回答ボタンのテキスト属性を定義
    let buttonTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 22, weight: .bold),
        .foregroundColor: UIColor.white,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アニメーション用のViewの準備
        prepareAnimationViews()
        
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        shindanViewModel.currentShindanArray = shindanViewModel.shindanArrays[0]
        questionText.text = shindanViewModel.shindanArrays[0][1]
        
        self.answerButton1.setAttributedTitle(
            NSAttributedString(string: self.shindanViewModel.currentShindanArray[3],
                               attributes: buttonTextAttributes),
            for: .normal
        )
        self.answerButton2.setAttributedTitle(
            NSAttributedString(string: self.shindanViewModel.currentShindanArray[4],
                               attributes: buttonTextAttributes),
            for: .normal
        )
    }
    
    @IBAction func answerButtonAction(_ sender: UIButton) {
        if String(sender.tag) == self.shindanViewModel.shindanArrays[self.shindanViewModel.count][2] {
            print("大丈夫です")
            // 誤差補正のためのアニメーション
            UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.answerButton1.layer.opacity = 0.0
                self.answerButton2.layer.opacity = 0.0
                self.questionText.center.x += 0.01
                self.questionNumber.center.x += 0.01
            }, completion: { _ in
                self.nextShindan()
            })
        } else {
            print("違反です")
            self.animateAndSegue()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先に受け渡すデータの処理
        if let nextView = segue.destination as? IhanViewController {
            nextView.argString = self.questionNumber.text
            nextView.questionText = self.questionText.text
            nextView.attentionText = shindanViewModel.currentShindanArray[5]
            nextView.kaisetsuText = shindanViewModel.currentShindanArray[6]
            nextView.sankouText = shindanViewModel.currentShindanArray[7]
        }
    }
    
    // 以下、アニメーションのための処理
    var animationView: UIView!
    
    var attentionImage: UIImage!
    var imageView: UIImageView!
    var upperRectView: UIView!
    var downerRectView: UIView!
    var upperAttentionsView: AttentionImageAndTextView!
    var downerAttentionsView: AttentionImageAndTextView!
    
    func prepareAnimationViews() {
        // アニメーション用のViewの準備
        self.attentionImage = UIImage(named:"attention_svg")!
        self.imageView = UIImageView(image: attentionImage)
        self.imageView.tintColor = .red
        let screenWidth: CGFloat = view.frame.width
        let screenHeight: CGFloat = view.frame.height
        let imgWidth: CGFloat = attentionImage.size.width
        let imgHeight: CGFloat = attentionImage.size.height
        let scale: CGFloat = screenWidth / imgWidth
        let rect: CGRect = CGRect(x: 0, y: 0, width: imgWidth * scale / 2.1, height: imgHeight * scale / 2.1)
        imageView.frame = rect
        imageView.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        imageView.layer.opacity = 0.0
        self.view.addSubview(imageView)
        
        upperRectView = UIView()
        upperRectView.backgroundColor = .red
        upperRectView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 3 )
        upperRectView.layer.opacity = 0.0
        self.view.addSubview(upperRectView)
        
        downerRectView = UIView()
        downerRectView.backgroundColor = .red
        downerRectView.frame = CGRect(x: 0, y: screenHeight * 2 / 3, width: screenWidth, height: screenHeight / 3 )
        downerRectView.layer.opacity = 0.0
        self.view.addSubview(downerRectView)
        
        upperAttentionsView = AttentionImageAndTextView(frame: CGRect(x: 0 , y: screenHeight * 0.34, width: screenWidth * 2 , height: 100))
        upperAttentionsView.backgroundColor = .clear
        upperAttentionsView.layer.opacity = 0.0
        self.view.addSubview(upperAttentionsView)
        
        downerAttentionsView = AttentionImageAndTextView(frame: CGRect(x: -(screenWidth * 0.5) , y: (screenHeight / 3) * 1.85 , width: screenWidth * 2 , height: 100))
        downerAttentionsView.backgroundColor = .clear
        downerAttentionsView.layer.opacity = 0.0
        self.view.addSubview(downerAttentionsView)
    }
    
    // 次の診断に進む
    func nextShindan(){
        if shindanViewModel.count < shindanViewModel.shindanArrays.count - 1 {
            shindanViewModel.count += 1
            shindanViewModel.currentShindanArray = shindanViewModel.shindanArrays[shindanViewModel.count]
            shindanViewModel.currentShindanNumber = shindanViewModel.count
            
            // アニメーション付きで前の問いを隠す
            UIView.animate(withDuration: 0.15, delay: 0.1, options: [], animations: {
                self.questionText.center.x -= 100
                self.questionText.layer.opacity = 0.0
                self.questionNumber.center.x -= 100
                self.questionNumber.layer.opacity = 0.0
            }, completion: { _ in
                // ビューのテキストを更新
                self.questionNumber.text = "Q.\(String(self.shindanViewModel.count + 1))"
                self.questionText.text = self.shindanViewModel.currentShindanArray[1]
                
                self.answerButton1.setAttributedTitle(
                    NSAttributedString(string: self.shindanViewModel.currentShindanArray[3],
                                       attributes: self.buttonTextAttributes),
                    for: .normal
                )
                self.answerButton2.setAttributedTitle(
                    NSAttributedString(string: self.shindanViewModel.currentShindanArray[4],
                                       attributes: self.buttonTextAttributes),
                    for: .normal
                )
                
                self.questionNumber.center.x += 200
                self.questionText.center.x += 200
                
                // アニメーション付きでテキストを再表示
                UIView.animate(withDuration: 0.15, delay: 0.3, options: [.curveEaseInOut], animations: {
                    self.questionNumber.center.x -= 100
                    self.questionText.center.x -= 100
                    
                    self.questionNumber.layer.opacity = 1.0
                    self.questionText.layer.opacity = 1.0
                    
                    self.answerButton1.layer.opacity = 1.0
                    self.answerButton2.layer.opacity = 1.0
                }, completion: { _ in
//                    self.answerButton2.isHidden = false
                } )
            })
        } else if shindanViewModel.count >= shindanViewModel.shindanArrays.count - 1 {
            // 最終画面に遷移
            performSegue(withIdentifier: "toLastViewSegue", sender: nil)
        }
    }
    
    // アニメーションを表示し、IhanViewに移行する
    func animateAndSegue(){
        // アラート音を再生
        playAlertAudio()
        
        UIView.animate(withDuration: 4.0, delay: 0.0, options: [.curveLinear], animations: {
            self.upperAttentionsView.center.x -= 200
            self.downerAttentionsView.center.x += 200
        }, completion: { _ in
            self.upperAttentionsView.center.x += 200
            self.downerAttentionsView.center.x -= 200
        })

        UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.upperRectView.layer.opacity = 0.8
                self.downerRectView.layer.opacity = 0.8
                self.upperAttentionsView.layer.opacity = 1
                self.downerAttentionsView.layer.opacity = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                self.imageView.layer.opacity = 0.8
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 1, animations: {
                self.imageView.layer.opacity = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
                self.imageView.layer.opacity = 0.8
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1, animations: {
                self.imageView.layer.opacity = 0.0
            })
        }) { _ in
            // アラート音をストップ
            stopAlertAudio()
            
            self.upperRectView.layer.opacity = 0.0
            self.downerRectView.layer.opacity = 0.0
            self.upperAttentionsView.layer.opacity = 0.0
            self.downerAttentionsView.layer.opacity = 0.0

            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "ihanView") as! IhanViewController
            nextView.argString = self.questionNumber.text
            nextView.questionText = self.questionText.text
            self.performSegue(withIdentifier: "toIhanView", sender: self)
        }
    }

}
