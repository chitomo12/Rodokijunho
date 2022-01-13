//
//  CustomNSObject.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/07.
//

import UIKit

// 診断モード開始時に表示するNSObject
class StartCheckingNSObject: NSObject {

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var startCheckingButton: UIButton!
    
    var startCheckingView: UIView!

    override init() {
        super.init()
        
        startCheckingView = UINib(nibName: "StartCheckingView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
//        label.text = "診断モード"
    }
}
