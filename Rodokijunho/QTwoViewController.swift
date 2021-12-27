//
//  QTwoViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import UIKit

class QTwoViewController: UIViewController {
    
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
            nextView.attentionText = "あなたの職場は〈労働基準法第二十八条違反〉の可能性があります。"
            nextView.kaisetsuText = "非雇用者の賃金は研修期間中であってもその地域の最低賃金以上でなければならないと労働基準法第二十八条、および最低賃金法に定められています。"
            nextView.sankouText = """
            労働基準法
            第二十八条　賃金の最低基準に関しては、最低賃金法（昭和三十四年法律第百三十七号）の定めるところによる。

            最低賃金法
            第四条　使用者は、最低賃金の適用を受ける労働者に対し、その最低賃金額以上の賃金を支払わなければならない。
            ２　最低賃金の適用を受ける労働者と使用者との間の労働契約で最低賃金額に達しない賃金を定めるものは、その部分については無効とする。この場合において、無効となつた部分は、最低賃金と同様の定をしたものとみなす。
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
        
        downerAttentionsView = AttentionImageAndTextView(frame: CGRect(x:-160 , y: (screenHeight / 3) * 2 - 35, width: screenWidth * 2 , height: 100))
        downerAttentionsView.backgroundColor = .clear
        downerAttentionsView.layer.opacity = 0.0
        self.view.addSubview(downerAttentionsView)
    }
    
    func animateAndSegue(){
        UIView.animate(withDuration: 4.0, delay: 0.0, options: [.curveLinear], animations: {
            self.upperAttentionsView.center.x -= 200
            self.downerAttentionsView.center.x += 200
        }, completion: nil)

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
            self.upperRectView.layer.opacity = 0.0
            self.downerRectView.layer.opacity = 0.0
            self.upperAttentionsView.layer.opacity = 0.0
            self.downerAttentionsView.layer.opacity = 0.0

            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "ihanView") as! IhanViewController
            nextView.argString = self.questionNumber.text
            nextView.questionText = self.questionText.text
            // ビューごとにセグエのIDを設定する
            self.performSegue(withIdentifier: "toIhanViewFromQTwo", sender: self)
        }
    }

}
