//
//  QuizListTableViewCell.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit
import Firebase

class QuizListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainTableLabel: UILabel!
    @IBOutlet weak var quizText: UILabel!
    @IBOutlet weak var correctlyAnsweredRateLabel: UILabel!
    
    @IBOutlet weak var mainTableImage: UIImageView!
    @IBOutlet weak var answerRecord: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func settingContents(indexPath: IndexPath, csvArray: [String], statisticData: Int) {
        let quizArray = csvArray[indexPath.row].components(separatedBy: ",")
        self.mainTableLabel.text = "\(quizArray[5])"
        self.quizText.text = "\(quizArray[1])"
        self.correctlyAnsweredRateLabel.text = "全ユーザー正答率：\(statisticData)％"
        if UserDefaults.standard.bool(forKey: "q\(indexPath.row + 1)_answeredCorrectly") == true {
            self.mainTableImage.image = UIImage(systemName: "circle")
            self.answerRecord.text = "正解"
        } else {
            self.mainTableImage.image = UIImage(systemName: "xmark")
            self.answerRecord.text = "不正解"
        }
    }
    

}
