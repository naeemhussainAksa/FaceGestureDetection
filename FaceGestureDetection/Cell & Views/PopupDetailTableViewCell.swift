//
//  PopupDetailTableViewCell.swift
//  KnowFace
//
//  Created by Naeem Hussain on 24/10/2022.
//

import UIKit

class PopupDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ obj : PopupFields)
    {
        nameLabel.text = obj.name
        detailLabel.text = obj.detail
    }
}
