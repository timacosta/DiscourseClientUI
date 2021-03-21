//
//  PinnedTopicCell.swift
//  DiscourseClient
//
//  Created by Tim Acosta on 21/3/21.
//  Copyright © 2021 Roberto Garrido. All rights reserved.
//

import UIKit

class PinnedTopicCell: UITableViewCell {
    
    @IBOutlet weak var orangeContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        
    }

    
    func configureUI() {
        orangeContainerView.layer.cornerRadius = 8
        titleLabel.font = UIFont.mainTitle
        bodyLabel.font = UIFont.cellDetailBold
    }
    
    
}
