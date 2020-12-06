//
//  ResourceListUIComposer.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 06/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class ResourceListUIComposer {
    private init() {}
    
    public static func resourceListComposedWith(listLoader: RemoteListLoader, selection: @escaping ((String) -> Void)) -> ResourceListCollectionViewController {
        let listViewModel = ListViewModel(listLoader: listLoader, url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=40")!)
        let refreshController = RefreshViewController(viewModel: listViewModel)
        let listViewController = ResourceListCollectionViewController(
            refreshController: refreshController,
            selection: selection)
        listViewModel.onListLoad = adaptResourceToCellControllers(forwardingTo: listViewController, using: listViewModel)
        listViewModel.onListFailure = handleLoadFailure(on: listViewController)
        return listViewController
    }
    
    private static func adaptResourceToCellControllers(forwardingTo controller: ResourceListCollectionViewController, using viewModel: ListViewModel) -> (ListItem) -> Void {
        return { [weak controller, weak viewModel] listItem in
            guard let viewModel = viewModel else { return }
            var collectionModel = [ResourceListCellController]()
            if viewModel.isFirstPage {
                collectionModel = listItem.results.map { model in
                    ResourceListCellController(model: model)
                }
            } else {
                let currentCollectionModel = controller?.collectionModel ?? []
                collectionModel = currentCollectionModel + listItem.results.map { model in
                    ResourceListCellController(model: model)
                }
            }
            controller?.collectionModel = collectionModel
        }
    }
    
    private static func handleLoadFailure(on listViewController: ResourceListCollectionViewController) -> () -> Void {
        return { [weak listViewController] in
            listViewController?.handleLoadFailure()
        }
    }
}
