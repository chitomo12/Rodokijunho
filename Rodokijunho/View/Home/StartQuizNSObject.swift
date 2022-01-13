//
//  StartQuizNSObject.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2022/01/08.
//

import UIKit

// クイズモード開始時に表示するNSObject
class StartQuizNSObject: NSObject {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var startQuizButton: UIButton!
    
    var startQuizView: UIView!

    override init() {
        super.init()
        
        startQuizView = UINib(nibName: "StartQuizView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
    }
}
