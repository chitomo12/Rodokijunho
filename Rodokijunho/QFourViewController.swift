//
//  QFourViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import UIKit

class QFourViewController: UIViewController {
    
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionText: UILabel!
    
    @IBAction func segueToIhan(_ sender: Any) {
        // 労基法違反ビューに遷移する際のアニメーション
        animateAndSegue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アニメーション用のViewの準備
        prepareAnimationViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先に受け渡すデータの処理
        if let nextView = segue.destination as? IhanViewController {
            nextView.argString = self.questionNumber.text
            nextView.questionText = self.questionText.text
            nextView.attentionText = "あなたの職場は〈労働基準法第三十六条違反〉の可能性があります。"
            nextView.kaisetsuText = "労働基準法では1日8時間及び1週40時間が労働時間の上限として定められています。この上限は、労働基準法第三十六条に従い使用者と労働者の間で書面による協定を行うことで、1ヶ月あたり45時間、1年あたり360時間にまで伸ばすことができます（通称「36協定」）。ただし、36協定を結んでも無限に残業させられるわけではなく、月45時間を超える残業は労働基準法違反になります。"
            nextView.sankouText = """
            労働基準法
            第三十六条　使用者は、当該事業場に、労働者の過半数で組織する労働組合がある場合においてはその労働組合、労働者の過半数で組織する労働組合がない場合においては労働者の過半数を代表する者との書面による協定をし、厚生労働省令で定めるところによりこれを行政官庁に届け出た場合においては、第三十二条から第三十二条の五まで若しくは第四十条の労働時間（以下この条において「労働時間」という。）又は前条の休日（以下この条において「休日」という。）に関する規定にかかわらず、その協定で定めるところによつて労働時間を延長し、又は休日に労働させることができる。
            ②　前項の協定においては、次に掲げる事項を定めるものとする。
            一　この条の規定により労働時間を延長し、又は休日に労働させることができることとされる労働者の範囲
            二　対象期間（この条の規定により労働時間を延長し、又は休日に労働させることができる期間をいい、一年間に限るものとする。第四号及び第六項第三号において同じ。）
            三　労働時間を延長し、又は休日に労働させることができる場合
            四　対象期間における一日、一箇月及び一年のそれぞれの期間について労働時間を延長して労働させることができる時間又は労働させることができる休日の日数
            五　労働時間の延長及び休日の労働を適正なものとするために必要な事項として厚生労働省令で定める事項
            ③　前項第四号の労働時間を延長して労働させることができる時間は、当該事業場の業務量、時間外労働の動向その他の事情を考慮して通常予見される時間外労働の範囲内において、限度時間を超えない時間に限る。
            ④　前項の限度時間は、一箇月について四十五時間及び一年について三百六十時間（第三十二条の四第一項第二号の対象期間として三箇月を超える期間を定めて同条の規定により労働させる場合にあつては、一箇月について四十二時間及び一年について三百二十時間）とする。

            """
        }
    }
    
    // 以下、アニメーションのための処理
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
        let rect: CGRect = CGRect(x: 0, y: 0, width: imgWidth * scale / 2, height: imgHeight * scale / 2)
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
        
        upperAttentionsView = AttentionImageAndTextView(frame: CGRect(x:0 , y: (screenHeight / 3) + 0, width: screenWidth * 2 , height: 100))
        upperAttentionsView.backgroundColor = .clear
        upperAttentionsView.layer.opacity = 0.0
        self.view.addSubview(upperAttentionsView)
        
        downerAttentionsView = AttentionImageAndTextView(frame: CGRect(x:-260 , y: (screenHeight / 3) * 2 - 35, width: screenWidth * 2 , height: 100))
        downerAttentionsView.backgroundColor = .clear
        downerAttentionsView.layer.opacity = 0.0
        self.view.addSubview(downerAttentionsView)
    }
    
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
            // ビューごとにセグエのIDを設定する
            self.performSegue(withIdentifier: "toIhanViewFromQFour", sender: self)
        }
    }

}
