//
//  TopicsViewModel.swift
//  DiscourseClient
//
//  Created by Roberto Garrido on 01/02/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import Foundation

/// Delegate a través del cual nos vamos a comunicar con el coordinator, contándole todo aquello que atañe a la navegación
protocol TopicsCoordinatorDelegate: class {
    func didSelect(topic: Topic)
    func topicsPlusButtonTapped()
}

/// Delegate a través del cual vamos a comunicar a la vista eventos que requiran pintar el UI, pasándole aquellos datos que necesita
protocol TopicsViewDelegate: class {
    func topicsFetched()
    func errorFetchingTopics()
}

/// ViewModel que representa un listado de topics
class TopicsViewModel {
    weak var coordinatorDelegate: TopicsCoordinatorDelegate?
    weak var viewDelegate: TopicsViewDelegate?
    let topicsDataManager: TopicsDataManager
    var topicViewModels: [TopicCellViewModel] = []
    var searchText: String? {
        didSet {
            if searchText != oldValue {
                viewDelegate?.topicsFetched()
                
            }
            
        }
        
    }
    
    //Filtered topics TODO://
    var filteredTopics: [TopicCellViewModel] {
        guard let searchText = searchText, !searchText.isEmpty else {return topicViewModels}
        
        return topicViewModels.filter { topic in
            guard let topic = topic as? TopicCellViewModel else {
                return true
            }
            
            return topic.textLabelText?.contains(searchText) ?? false
            
        }
        
    }

    init(topicsDataManager: TopicsDataManager) {
        self.topicsDataManager = topicsDataManager
    }

    fileprivate func fetchTopicsAndReloadUI() {
        topicsDataManager.fetchAllTopics { [weak self] (result) in
            switch result {
            case .success(let topicsResponse):
                guard let topics = topicsResponse?.topicList.topics,
                      let users = topicsResponse?.users else { return }
                
                let fetchedTopic: [TopicCellViewModel] = topics.compactMap({ topic in
                    guard let lastPoster = users.first(where: { $0.username == topic.lastPosterUsername}) else {
                        return nil
                    }
                    
                    return TopicCellViewModel(topic: topic, lastPoster: lastPoster)
                    
                })
                
                self?.topicViewModels.append(contentsOf: fetchedTopic)
                
                
                
                //self?.topicViewModels = topics.map({ TopicCellViewModel(topic: $0, lastPoster: $0.lastPosterUsername) })
                self?.viewDelegate?.topicsFetched()
            case .failure:
                self?.viewDelegate?.errorFetchingTopics()
            }
        }
    }
    
    func refreshTopics(){
        
        //topicViewModels = [PinnedTopicCellViewModel()]
        fetchTopicsAndReloadUI()
    }

    func viewWasLoaded() {
        fetchTopicsAndReloadUI()
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        return topicViewModels.count
    }

    func viewModel(at indexPath: IndexPath) -> TopicCellViewModel? {
        guard indexPath.row < topicViewModels.count else { return nil }
        return topicViewModels[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < topicViewModels.count else { return }
        coordinatorDelegate?.didSelect(topic: topicViewModels[indexPath.row].topic)
    }

    func plusButtonTapped() {
        coordinatorDelegate?.topicsPlusButtonTapped()
    }
    
    func newTopicWasCreated() {
        fetchTopicsAndReloadUI()
    }

    func topicWasDeleted() {
        fetchTopicsAndReloadUI()
    }
}
