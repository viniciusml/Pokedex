//
//  ViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class ResourceListCollectionViewController: UICollectionViewController {

    private var loader: ListLoader?
    private var alertPresenter: AlertPresenter?
    private var collectionModel = [ResultItem]()

    private var prefetchTriggerCount: Int {
        collectionModel.count - 10
    }

    private var selection: ((String) -> Void)? = nil

    public convenience init(loader: ListLoader, alertPresenter: AlertPresenter, selection: @escaping (String) -> Void) {
        self.init(collectionViewLayout: UICollectionViewLayout())
        self.loader = loader
        self.alertPresenter = alertPresenter
        self.selection = selection
    }

    // MARK: - View Controller Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokédex"

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        collectionView.prefetchDataSource = self
        collectionView.register(ListCell.self)
        load()
    }

    // MARK: - Helpers

    @objc private func load() {
        collectionView.refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(items):
                self.collectionModel = items
                self.collectionView.reloadData()
            case .failure:
                self.alertPresenter?.presentAlert(title: "Alert", message: "An error ocurred. Please try again", on: self)
            }

            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    func calculateIndexPathsToReload(from newItems: [ResultItem]) -> [IndexPath] {

        let startIndex = collectionModel.count - newItems.count

        let endIndex = startIndex + newItems.count

        return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
    }

    func isDisplayingCell(for indexPath: IndexPath) -> Bool {
        indexPath.item >= prefetchTriggerCount
    }
}

    // MARK: - Collection View Data Source and Delegate

extension ResourceListCollectionViewController: UICollectionViewDelegateFlowLayout {

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionModel[indexPath.item]
        selection?(item.url)
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionModel.count
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = collectionModel[indexPath.item]
        let cell = collectionView.dequeueReusableCell(type: ListCell.self, for: indexPath)
        cell.nameLabel.text = cellModel.name
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (view.frame.width - 36) / 3
        let height = width * 0.8
        return CGSize(width: width, height: height)
    }
}

    // MARK: - Collection View Data Source Prefetching

extension ResourceListCollectionViewController: UICollectionViewDataSourcePrefetching {

    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isDisplayingCell) {
            loader?.load { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .success(items):
                    self.collectionModel.append(contentsOf: items)

                    let indexesToReload = self.calculateIndexPathsToReload(from: items)
                    self.collectionView.insertItems(at: indexesToReload)
                    self.collectionView.reloadItems(at: indexesToReload)
                case .failure:
                    self.alertPresenter?.presentAlert(title: "Alert", message: "An error ocurred. Please try again", on: self)
                }
            }
        }
    }
}

