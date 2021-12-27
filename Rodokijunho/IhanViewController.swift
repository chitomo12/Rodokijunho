//
//  IhanViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/26.
//

import UIKit

class IhanViewController: UIViewController {
    
    var argString: String? = ""
    var questionText: String? = ""
    var attentionText: String? = ""
    var kaisetsuText: String? = ""
    var sankouText: String? = ""

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var attentionMessage: UILabel!
    @IBOutlet weak var kaisetsu: UILabel!
    @IBOutlet weak var sankoujoubun: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.questionNumber.text = argString
        self.questionTextLabel.text = questionText
        self.attentionMessage.text = attentionText
        self.kaisetsu.text = kaisetsuText
        
        self.sankoujoubun.text = sankouText

        //スクロール領域の設定
        print("①self.contentView.frame.size.height: \(self.contentView.frame.size.height)")
        scrollView.contentSize = CGSize(width: view.frame.size.width,
                                        height: self.contentView.frame.size.height)
        
        print("②sankoujoubun.frame.height: \(sankoujoubun.frame.height)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ここでテキストが読み込まれた後のフレームサイズが取得できる
        print("②sankoujoubun.frame.height: \(sankoujoubun.frame.height)")
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = .init(x: 0, y: 0, width: view.frame.size.width, height: contentView.frame.size.height + sankoujoubun.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: contentView.frame.size.height)

    }
    
    @IBAction func shareButton(_ sender: Any) {
        print("シェアボタンを押しました")
        let shareText = "\(self.attentionText!)\n#アプリ労働基準法"
        let shareItems = [shareText]
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = view
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func backToTitle(_ sender: Any) {
        print("タイトルに戻ります")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
