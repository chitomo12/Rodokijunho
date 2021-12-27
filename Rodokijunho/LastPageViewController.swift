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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    @IBAction func backToTitleButton(_ sender: Any) {
        print("タイトルに戻ります")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
