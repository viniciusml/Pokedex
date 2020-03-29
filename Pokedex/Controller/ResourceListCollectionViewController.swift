//
//  ViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class ResourceListCollectionViewController: UICollectionViewController {
    
    public var listViewModel: ListViewModel!
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Pokédex"
        
        listViewModel = ListViewModel(delegate: self)
        collectionView.prefetchDataSource = self
        listViewModel.fetchResourceList()
        
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.isPrefetchingEnabled = true
    }
    
    func isDisplayingCell(for indexPath: IndexPath) -> Bool {
        
        return indexPath.item >= listViewModel.resources.count - 15
    }
}

extension ResourceListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.resources.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = listViewModel.resources[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell {
            cell.item = item
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        let height = width * 0.8
        return CGSize(width: width, height: height)
    }
}

extension ResourceListCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        // Prefetchs data
        if indexPaths.contains(where: isDisplayingCell) {
            listViewModel.fetchResourceList()
        }
    }
}

extension ResourceListCollectionViewController: ListViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        
        collectionView.insertItems(at: newIndexPathsToReload)
        collectionView.reloadItems(at: newIndexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        debugPrint("🛑⚠️ \(reason) ⚠️🛑")
    }
}
