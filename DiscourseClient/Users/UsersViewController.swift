//
//  UsersViewController.swift
//  DiscourseClient
//
//  Created by Roberto Garrido on 28/03/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    let viewModel: UsersViewModel
    
    lazy private var flowLayout: UICollectionViewFlowLayout = {
        let numberOfColumns: Int = 3
        let sectionInset: CGFloat = 24
        let minimumInteritemSpacing: CGFloat = 34
        let minimumLineSpacing: CGFloat = 19
        let cellHeight: CGFloat = 123
        
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = (UIScreen.main.bounds.width - sectionInset * 2 - minimumInteritemSpacing * (CGFloat(numberOfColumns) - 1)) / CGFloat(numberOfColumns)
        layout.itemSize = CGSize(width: width, height: cellHeight)
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        return layout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        return collectionView
    }()

    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewWasLoaded()
        configureNavigationBar()
    }
    
    @objc func plusButtonTapped() {
        //TODO
    }
    
    @objc func searchTopicTapped() {
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = nil
        
        let addUserIcon = UIImage(named: "icoAdd")?.withRenderingMode(.alwaysTemplate)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: addUserIcon, style: .plain, target: self, action: #selector(plusButtonTapped))
        leftBarButtonItem.tintColor = .orangeKCPumpkin
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let searchTopicButton = UIImage(named: "icoSearch")?.withRenderingMode(.alwaysTemplate)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: searchTopicButton, style: .plain, target: self, action: #selector(searchTopicTapped))
        rightBarButtonItem.tintColor = .orangeKCPumpkin
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }

    fileprivate func showErrorFetchingUsers() {
        showAlert("Error fetching users\nPlease try again later")
    }
}


extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath)
    }
}

extension UsersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as? UserCell, let cellViewModel = viewModel.viewModel(at: indexPath) else {
            fatalError()
        }
        
        cell.viewModel = cellViewModel
        return cell
    }
}

extension UsersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}


extension UsersViewController: UsersViewModelViewDelegate {
    func usersWereFetched() {
        collectionView.reloadData()
    }

    func errorFetchingUsers() {
        showErrorFetchingUsers()
    }
}
