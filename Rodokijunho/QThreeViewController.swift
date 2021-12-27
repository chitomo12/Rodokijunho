//
//  QThreeViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import UIKit

class QThreeViewController: UIViewController {
    
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
            nextView.attentionText = "あなたの職場は〈労働基準法第二十四条違反〉の可能性があります。"
            nextView.kaisetsuText = "制服への着替えや掃除など、自発的にではなく会社からの命令で行う業務は全て業務時間の中に含まれます。ここに掛かる時間分の賃金を支払わなければ、賃金未払いとして労働基準法第二十四条違反となります。"
            nextView.sankouText = """
            労働基準法
            第二十四条　賃金は、通貨で、直接労働者に、その全額を支払わなければならない。ただし、法令若しくは労働協約に別段の定めがある場合又は厚生労働省令で定める賃金について確実な支払の方法で厚生労働省令で定めるものによる場合においては、通貨以外のもので支払い、また、法令に別段の定めがある場合又は当該事業場の労働者の過半数で組織する労働組合があるときはその労働組合、労働者の過半数で組織する労働組合がないときは労働者の過半数を代表する者との書面による協定がある場合においては、賃金の一部を控除して支払うことができる。
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
            self.performSegue(withIdentifier: "toIhanViewFromQThree", sender: self)
        }
    }

}
