//
//  ListViewModel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class ListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let listLoader: RemoteListLoader
    private let url: URL
    
    public init(listLoader: RemoteListLoader, url: URL) {
        self.listLoader = listLoader
        self.url = url
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onListLoad: Observer<ListItem>?
    var onListFailure: (() -> Void)?
    
    private var fetchedList: ListItem?
    
    var isFirstPage: Bool {
        guard let fetchedList = fetchedList else { return true }
        return fetchedList.previous == nil
    }
    
    var nextURLString: String? {
        fetchedList.map { $0.next }
    }
    
    func loadList() {
        onLoadingStateChange?(true)
        listLoader.load(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case let .success(item):
                    self.fetchedList = item
                    self.onListLoad?(item)
                case .failure:
                    self.onListFailure?()
            }

            self.onLoadingStateChange?(false)
        }
    }
    
    func loadMore() {
        guard let next = nextURLString,
              let url = URL(string: next) else { return }
        
        listLoader.load(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case let .success(item):
                    self.fetchedList = item
                    self.onListLoad?(item)
                case .failure:
                    self.onListFailure?()
            }
        }
    }
}
