//
//  ScoreViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/31.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultComment: UILabel!

    var score: Int = 0
    var numberOfQuiz: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scoreLabel.text = "\(score)点 / \(numberOfQuiz)点"
        
        self.navigationController?.navigationBar.isHidden = true
        
        if Float(score) / Float(numberOfQuiz) == 1 {
            self.resultComment.text = "完璧です！その知見を周りに伝授しましょう！"
        } else if Float(score) / Float(numberOfQuiz) >= 0.5 {
            self.resultComment.text = "よく勉強してます！素晴らしい！💮"
        } else {
            self.resultComment.text = "ちょっと社会に出るには心配かも…💦"
        }
    }
    
    @IBAction func toTitleButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
