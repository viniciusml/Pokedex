//
//  ViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class ResourceListCollectionViewController: UICollectionViewController {

    private var refreshController: RefreshViewController?
    var collectionModel = [ResourceListCellController]() {
        didSet { collectionView.reloadData() }
    }

    private var prefetchTriggerCount: Int {
        collectionModel.count - 10
    }

    private var selection: ((String) -> Void)? = nil

    public convenience init(refreshController: RefreshViewController, selection: @escaping (String) -> Void) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.refreshController = refreshController
        self.selection = selection
    }

    // MARK: - View Controller Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokédex"

        collectionView.refreshControl = refreshController?.view
        refreshController?.refresh()
        collectionView.register(ListCell.self)
        collectionView.backgroundColor = .white
    }

    // MARK: - Helpers

    func handleLoadFailure() {
        showBasicAlert(title: "Alert", message: "An error ocurred. Please try again")
    }
}

    // MARK: - Collection View Data Source and Delegate

extension ResourceListCollectionViewController: UICollectionViewDelegateFlowLayout {

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection?(cellController(for: indexPath).url)
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionModel.count
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cellController(for: indexPath).view(collectionView, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 36) / 3
        let height = width * 0.8
        return CGSize(width: width, height: height)
    }
    
    func cellController(for indexPath: IndexPath) -> ResourceListCellController {
        collectionModel[indexPath.item]
    }
    
    public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == prefetchTriggerCount {
            refreshController?.loadMore()
        }
    }
}

