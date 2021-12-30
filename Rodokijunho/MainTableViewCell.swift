//
//  MainTableViewCell.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/30.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTableLabel: UILabel!
    @IBOutlet weak var mainTableImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func settingContents(indexPath: IndexPath) {
        self.mainTableLabel.text = "Question: \(String(indexPath.row))"
        self.mainTableImage.image = UIImage(systemName: "xmark")
    }
    
}
