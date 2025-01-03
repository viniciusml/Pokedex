//
//  ResourceListCollectionViewController+TestHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Pokedex
import UIKit

extension ResourceListCollectionViewController {
    func simulateUserInitiatedReload() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        collectionView.refreshControl?.isRefreshing == true
    }
    
    var prefetchTrigger: Int { 10 }
    
    func numberOfRenderedResourceItems() -> Int {
        collectionView.numberOfItems(inSection: resourceItemsSection)
    }
    
    private var resourceItemsSection: Int { 0 }
    
    func listItem(at item: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(item: item, section: resourceItemsSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
    
    func loadAndDisplayViewIfNeeded() {
        loadViewIfNeeded()
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func simulateResourceItemViewNearVisible(at item: Int) {
        let dl = collectionView.delegate
        let index = IndexPath(item: item, section: resourceItemsSection)
        let cell = listItem(at: item)!
        dl?.collectionView?(collectionView, willDisplay: cell, forItemAt: index)
    }
    
    func simulateResourceItemSelection(item: Int) {
        let dl = collectionView.delegate
        let indexPath = IndexPath(item: item, section: resourceItemsSection)
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}
