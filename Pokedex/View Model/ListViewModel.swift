//
//  ListViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

protocol ListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

public class ListViewModel {

    let client = AFHTTPClient()

    var loader: RemoteLoader<ListItem> {
        RemoteLoader(client: client, mapper: ListItemMapper.map)
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

//        loader.loadResourceList(page: currentPage.toOffset()) { result in
//            switch result {
//            case .success(let item):
//
//                DispatchQueue.main.async {
//
//                    self.isFetchInProgress = false
//
//                    self.resources.append(contentsOf: item.results)
//
//                    if self.currentPage > 1 {
//
//                        // Index paths to update collection.
//                        let indexPathsToReload =
//                            self.calculateIndexPathsToReload(
//                                from: item.results)
//
//                        // Inform delegate there's new data available to load.
//                        self.resourcesDelegate?.onFetchCompleted(
//                            with: indexPathsToReload)
//                    } else {
//                        // Inform delegate there's first amount of data to load
//                        self.resourcesDelegate?.onFetchCompleted(
//                            with: .none)
//                    }
//
//                    self.currentPage += 1
//                }
//            case .failure(let error):
//
//                DispatchQueue.main.async {
//                    self.isFetchInProgress = false
//
//                    // Inform delegate the motive of failure
//                    self.resourcesDelegate?.onFetchFailed(
//                        with: error.localizedDescription)
//                }
//            }
//        }
    }

    // MARK: - Helper Functions

    // Returns a List Item for a specific index. Used to configure cell.
    private func item(at index: Int) -> ResultItem {
        resources[index]
    }

    // Calculates the index paths for the last page of resources received from the API.
    private func calculateIndexPathsToReload(from newResources: [ResultItem]) -> [IndexPath] {

        let startIndex = resources.count - newResources.count

        let endIndex = startIndex + newResources.count

        return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
    }
}

extension Int {

    /// Converts page into offset, to be used as parameter for the API call.
    fileprivate func toOffset() -> String {
        String(self * 20)
    }
}
