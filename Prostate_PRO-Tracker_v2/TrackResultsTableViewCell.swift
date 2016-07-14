//
//  TrackResultsTableViewCell.swift
//  Prostate Cancer
//
//  Created by Jackson Thea on 10/17/15.
//  Copyright © 2015 Jackson Thea. All rights reserved.
//

import UIKit

class TrackResultsTableViewCell: UITableViewCell {
    
    var title: String? {
        didSet {
            updateUI()
        }
    }
    
    var index: Int = 0
    
    @IBOutlet weak var cellTitle: UILabel!
    //@IBOutlet weak var cellSubtitle: UILabel!
    
    func updateUI() {
        cellTitle?.text = title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
