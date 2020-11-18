//
//  ResourceListCellController.swift
//  Pokedex
//
//  Created by Vinicius Leal on 28/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

final public class ResourceListCellController {
    let model: ResultItem
    
    var url: String {
        model.url
    }
    
    init(model: ResultItem) {
        self.model = model
    }
    
    func view(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: ListCell.self, for: indexPath)
        cell.nameLabel.text = model.name
        return cell
    }
}
