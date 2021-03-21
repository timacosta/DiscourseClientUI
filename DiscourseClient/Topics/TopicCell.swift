//
//  TopicCell.swift
//  DiscourseClient
//
//  Created by Roberto Garrido on 08/02/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit

/// Celda que representa un topic en la lista
class TopicCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var lastPostImage: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var posterCountLabel: UILabel!
    @IBOutlet weak var lastPostDateLabel: UILabel!
    
    
    
    var viewModel: TopicCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            postTitleLabel.text = viewModel.textLabelText
            postCountLabel.text = viewModel.postCount
            posterCountLabel.text = viewModel.postersCount
            lastPostDateLabel.text = viewModel.lastPostDate
            lastPostImage.image = viewModel.lastPosterImage
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurationOfUI()
    }
    
    
    private func configurationOfUI() {
        lastPostImage.layer.cornerRadius = lastPostImage.frame.height / 2
        postTitleLabel.font = UIFont.title
        
        postCountLabel.font = UIFont.cellDetail
        posterCountLabel.font = UIFont.cellDetail
        lastPostDateLabel.font = UIFont.cellDetailBold
        
    }
    
}

extension TopicCell: TableViewCellProtocol {
    
}


