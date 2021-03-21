//
//  TopicCellViewModel.swift
//  DiscourseClient
//
//  Created by Roberto Garrido on 08/02/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit

protocol TopicCellViewModelDelegate: class {
    func userImageFetched()
}

/// ViewModel que representa un topic en la lista
class TopicCellViewModel: TableViewCellProtocol {
    
    //MARK: - Constants
    let topic: Topic
    let lastPoster: User
    let staticImageSize = 100
    
    //MARK: - Variables
    var textLabelText: String?
    var postCount: String?
    var postersCount: String?
    var lastPostDate: String?
    var lastPosterImage: UIImage? //Add functions imagefetched.
    
    init(topic: Topic, lastPoster: User) {
        self.topic = topic
        self.lastPoster = lastPoster
        
        self.textLabelText = topic.title
        self.postCount = "\(topic.postsCount)"
        self.postersCount = "\(topic.posters.count)"
        self.lastPostDate = ""
        
        //Format date
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let lastPostDate = formatter.date(from: topic.lastPostedAt) {
            formatter.dateFormat = "MMM d"
            self.lastPostDate = formatter.string(from: lastPostDate).capitalized
        }
        
        let userURL: String = lastPoster.avatarTemplate.replacingOccurrences(of: "{size}", with: "\(self.staticImageSize)")
        
        if let imageURL = URL(string: "\(apiURL)\(userURL)") {
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                
                guard let data = try? Data(contentsOf: imageURL),
                      let image = UIImage(data: data) else {return}
                
                DispatchQueue.main.async {
                    self?.lastPosterImage = image
                }
                
            }
        }
        
        
        
        
    }
}
