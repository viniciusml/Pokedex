//
//  PhotoIndicator.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

/// A view that displays a horizontal series of dots, each of which corresponds to an image in PhotoCarousel.
///
/// Creates an effect very simmilar to UIPageControl, but with no need of creating a UIPageViewController.
class PhotoIndicator: UIView {

    // MARK: - Properties

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    var imagesAvailable = [String]()

    var index = 0

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCollectionView()

        observeSelectedIndex()

        observeNumberOfImages()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper Functions

    func setupCollectionView() {
        collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCell.identifier)

        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.fillSuperview()
        collectionView.isScrollEnabled = false
    }

    // Observe changes in the index of PhotoCarousel Cell being displayed, in order to set IndicatorCell as selected.
    func observeSelectedIndex() {
        NotificationCenter.default.addObserver(forName: .saveIndex, object: nil, queue: OperationQueue.main) { (notification) in

            let photoCarousel = notification.object as! PhotoCarousel
            self.index = photoCarousel.testIndex

            let newSelectedIndexPath = NSIndexPath(item: self.index, section: 0)
            self.collectionView.selectItem(at: newSelectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        }
    }

    // Observe items in the imagesAvailable array, in order to set number of IndicatorCells.
    func observeNumberOfImages() {
        NotificationCenter.default.addObserver(forName: .saveImagesUrlAvailable, object: nil, queue: OperationQueue.main) { (notification) in

            let viewModel = notification.object as! PokemonViewModel
            self.imagesAvailable = viewModel.imagesAvailable
            self.collectionView.reloadData()

            //Initialize with first IndicatorCell selected.
            let selectedIndexPath = NSIndexPath(item: self.index, section: 0)
            self.collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        }
    }

}

// MARK: - Collection View Delegate

extension PhotoIndicator: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesAvailable.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.identifier, for: indexPath) as! IndicatorCell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / CGFloat(imagesAvailable.count)
        return CGSize(width: width, height: 12)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
