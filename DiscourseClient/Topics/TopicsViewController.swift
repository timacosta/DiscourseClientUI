//
//  TopicsViewController.swift
//  DiscourseClient
//
//  Created by Roberto Garrido on 01/02/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit

/// ViewController que representa un listado de topics
class TopicsViewController: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "PinnedTopicCell", bundle: nil), forCellReuseIdentifier: "PinnedTopicCell")
        table.register(UINib(nibName: "TopicCell", bundle: nil), forCellReuseIdentifier: "TopicCell")
        //table.estimatedRowHeight = 100
        //table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    lazy var floatingActionButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icoNew")?.withRenderingMode(.alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped)))
        
        return imageView
        
    }()
    
    lazy var searchBar = UISearchBar()

    let viewModel: TopicsViewModel
    private let defaultFloatingButtonBottomSpace: CGFloat = -12
    private var floatingButtonBottomConstraint: NSLayoutConstraint?
    

    init(viewModel: TopicsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(floatingActionButton)
        let bottomConstraint = floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: defaultFloatingButtonBottomSpace)
        floatingButtonBottomConstraint = bottomConstraint
        NSLayoutConstraint.activate([
            floatingActionButton.widthAnchor.constraint(equalToConstant: floatingActionButton.bounds.height),
            floatingActionButton.heightAnchor.constraint(equalToConstant: floatingActionButton.bounds.width),
            floatingActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            bottomConstraint
            
        ])

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewWasLoaded()
        
        configureNavigationBar()
        searchTopicConfiguration()
        
    }

    @objc func plusButtonTapped() {
        viewModel.plusButtonTapped()
    }
    
    @objc func searchTopicTapped() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        searchBar.text = ""
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func searchTopicConfiguration() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.tintColor = .orangeKCPumpkin
        
        let textFieldInsideUISerachBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISerachBar?.textColor = .blackKC
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = nil
        
        let addTopicIcon = UIImage(named: "icoAdd")?.withRenderingMode(.alwaysTemplate)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: addTopicIcon, style: .plain, target: self, action: #selector(plusButtonTapped))
        leftBarButtonItem.tintColor = .orangeKCPumpkin
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let searchTopicButton = UIImage(named: "icoSearch")?.withRenderingMode(.alwaysTemplate)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: searchTopicButton, style: .plain, target: self, action: #selector(searchTopicTapped))
        rightBarButtonItem.tintColor = .orangeKCPumpkin
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }

    fileprivate func showErrorFetchingTopicsAlert() {
        let alertMessage: String = NSLocalizedString("Error fetching topics\nPlease try again later", comment: "")
        showAlert(alertMessage)
    }
    
    func searchTopics(text: String?) {
        viewModel.searchText = text
    }
    
}



//MARK: - Extension UITableViewDataSource
extension TopicsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as? TopicCell,
            let cellViewModel = viewModel.viewModel(at: indexPath) {
            cell.viewModel = cellViewModel
            return cell
        }
        
        if let pinnedCell = tableView.dequeueReusableCell(withIdentifier: "PinnedTopicCell", for: indexPath) as? PinnedTopicCell {
            
            return pinnedCell
            
        }

        fatalError()
    }
}



extension TopicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath)
    }
}

extension TopicsViewController: TopicsViewDelegate {
    func topicsFetched() {
        tableView.reloadData()
    }

    func errorFetchingTopics() {
        showErrorFetchingTopicsAlert()
    }
}


//MARK: - UISearchBarDelegate
extension TopicsViewController: UISearchBarDelegate {
    func cancelSearchFilter() {
        
    }
    
    
}
