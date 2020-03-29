//
//  ListViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

import Foundation

protocol ListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

public class ListViewModel {
    
    let client = HTTPClient()
    
    var loader: RemoteLoader {
        RemoteLoader(client: client)
    }
    
    weak var resourcesDelegate: ListViewModelDelegate?
    
    public var resources = [ResultItem]()
    
    var currentPage = 0
    
    var isFetchInProgress = false
        
    init(delegate: ListViewModelDelegate) {
        
        self.resourcesDelegate = delegate
    }
    
    
    func fetchResourceList() {
        
        // Prevents multiple requests happening.
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true

        loader.loadResourceList(page: currentPage.toOffset()) { result in
            switch result {
            case .success(let item):
                
                DispatchQueue.main.async {
                    
                    self.isFetchInProgress = false
                    
                    self.resources.append(contentsOf: item.results)
                    
                    if self.currentPage > 1 {
                        
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: item.results)
                        
                        self.resourcesDelegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        
                        self.resourcesDelegate?.onFetchCompleted(with: .none)
                    }
                    
                    self.currentPage += 1
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    
                    self.resourcesDelegate?.onFetchFailed(with: error.localizedDescription)
                }
            }
        }
    }
        
    func item(at index: Int) -> ResultItem {
        return resources[index]
    }
    
    func calculateIndexPathsToReload(from newResources: [ResultItem]) -> [IndexPath] {
        
        let startIndex = resources.count - newResources.count
        
        let endIndex = startIndex + newResources.count
        
        return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
    }
}

private extension Int {
    func toOffset() -> String {
        let offset = self * 20
        return String(offset)
    }
}
