//
//  QOneViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/26.
//

import UIKit
import AVFoundation

class QOneViewController: UIViewController {

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
            nextView.attentionText = "あなたの職場は〈労働基準法第八十九条違反〉の可能性があります。"
            nextView.kaisetsuText = "常時10人以上が在籍する職場には就業規則の策定が労働基準法第八十九条により義務付けられています。\n仮に従業員数10人未満の職場であっても、無用なトラブルを避けるために就業規則の設置が推奨されています。"
            nextView.sankouText = """
            労働基準法
            第八十九条　常時十人以上の労働者を使用する使用者は、次に掲げる事項について就業規則を作成し、行政官庁に届け出なければならない。次に掲げる事項を変更した場合においても、同様とする。
            一　始業及び終業の時刻、休憩時間、休日、休暇並びに労働者を二組以上に分けて交替に就業させる場合においては就業時転換に関する事項
            二　賃金（臨時の賃金等を除く。以下この号において同じ。）の決定、計算及び支払の方法、賃金の締切り及び支払の時期並びに昇給に関する事項
            三　退職に関する事項（解雇の事由を含む。）
            三の二　退職手当の定めをする場合においては、適用される労働者の範囲、退職手当の決定、計算及び支払の方法並びに退職手当の支払の時期に関する事項
            四　臨時の賃金等（退職手当を除く。）及び最低賃金額の定めをする場合においては、これに関する事項
            五　労働者に食費、作業用品その他の負担をさせる定めをする場合においては、これに関する事項
            六　安全及び衛生に関する定めをする場合においては、これに関する事項
            七　職業訓練に関する定めをする場合においては、これに関する事項
            八　災害補償及び業務外の傷病扶助に関する定めをする場合においては、これに関する事項
            九　表彰及び制裁の定めをする場合においては、その種類及び程度に関する事項
            十　前各号に掲げるもののほか、当該事業場の労働者のすべてに適用される定めをする場合においては、これに関する事項
        """
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
            self.performSegue(withIdentifier: "toIhanView", sender: self)
        }
    }

}
