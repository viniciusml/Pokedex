//
//  ListCell.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class ListCell: BaseCell {

    //    MARK: - Properties

    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font.medium, size: 16)!
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    var pokeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pokeball")
        return iv
    }()

    static var identifier: String {
        return String(describing: self)
    }

    var item: ResultItem? {
        didSet {
            nameLabel.text = item?.name.capitalized
        }
    }

    // MARK: - Helpers

    override func setupViews() {
        backgroundColor = .cellColor
        layer.cornerRadius = 10

        addSubview(nameLabel)
        nameLabel.anchor(
            top: self.topAnchor, leading: self.leadingAnchor, bottom: nil,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 0))

        addSubview(pokeImage)
        pokeImage.anchor(
            top: nil, leading: nil, bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5),
            size: CGSize(width: 40, height: 40))
    }
}
