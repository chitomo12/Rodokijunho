//
//  LastPageViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import UIKit

class LastPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func openRodokijunho(_ sender: Any) {
        print("労働基準法のページを表示します")
        if let url = URL(string: "https://elaws.e-gov.go.jp/document?lawid=322AC0000000049") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func openKoseirodosho(_ sender: Any) {
        print("厚生労働省のHPを開きます")
        if let url = URL(string: "https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/koyou_roudou/roudoukijun/faq/faq_kijyunhou.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func backToTitle(_ sender: Any) {
        print("タイトルに戻ります")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
