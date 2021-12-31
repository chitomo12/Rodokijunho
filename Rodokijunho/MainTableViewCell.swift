//
//  MainTableViewCell.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var mainTableLabel: UILabel!
    @IBOutlet weak var quizText: UILabel!
    
    @IBOutlet weak var mainTableImage: UIImageView!
    @IBOutlet weak var answerRecord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func settingContents(indexPath: IndexPath, csvArray: [String]) {
        let quizArray = csvArray[indexPath.row].components(separatedBy: ",")
//        self.mainTableLabel.text = "Question: \(String(indexPath.row))"
        self.mainTableLabel.text = "\(quizArray[5])"
        self.quizText.text = "\(quizArray[1])"
        if UserDefaults.standard.bool(forKey: "q\(indexPath.row + 1)_answeredCorrectly") == true {
//            print("load: q\(indexPath.row)_answeredCorrectly == true")
            self.mainTableImage.image = UIImage(systemName: "circle")
            self.answerRecord.text = "正解"
        } else {
//            print("load: q\(indexPath.row)_answeredCorrectly == false")
            self.mainTableImage.image = UIImage(systemName: "xmark")
            self.answerRecord.text = "不正解"
        }
    }
    
}
