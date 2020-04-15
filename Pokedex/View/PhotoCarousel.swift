//
//  PhotoCarousel.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

/// A view that displays a horizontal series of cells, each of which presents to an image, creating a carousel effect.
///
/// Creates an effect very simmilar to UIPageViewController, but with no need of creating a controller.
class PhotoCarousel: UIView {

    // MARK: - Properties

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    var testIndex = Int()

    var imagesAvailable = [String]()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCollectionView()

        observeSelectedIndex()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    func setupCollectionView() {

        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }

        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }

    // Observe items in the imagesAvailable array, in order to set number of PhotoCells,
    // and to load the images in cellForItemAt.
    func observeSelectedIndex() {
        NotificationCenter.default.addObserver(forName: .saveImagesUrlAvailable, object: nil, queue: OperationQueue.main) { (notification) in

            let viewModel = notification.object as! PokemonViewModel
            self.imagesAvailable = viewModel.imagesAvailable
            self.collectionView.reloadData()

        }
    }
}

extension PhotoCarousel: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesAvailable.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell

        let productPhoto = imagesAvailable[indexPath.item]
        cell.photoImageView.loadImage(urlString: productPhoto)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        // Identify which index collection view ended the drag movement.
        let index = targetContentOffset.pointee.x / self.frame.width

        testIndex = Int(index)

        // Post a notification to be received in PhotoIndicator,
        //in order to select the cell for the same index.
        NotificationCenter.default.post(name: .saveIndex, object: self)
    }

}
