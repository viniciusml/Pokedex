//
//  RefreshViewController.swift
//  Pokedex
//
//  Created by Vinicius Leal on 28/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

final public class RefreshViewController: NSObject {
    private let loadingIndicator: UIRefreshControl = {
        $0.isAccessibilityElement = true
        $0.accessibilityLabel = "Loading Pokémons"
        return $0
    }(UIRefreshControl())
    
    private(set) lazy var view = binded(loadingIndicator)
    
    private let viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadList()
    }
    
    func loadMore() {
        viewModel.loadMore()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
