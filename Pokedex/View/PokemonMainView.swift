//
//  PokemonMainView.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class PokemonMainView: UIView {

    //    MARK: - Properties

    var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font.bold, size: 34)!
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font.medium, size: 14)!
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font.medium, size: 14)!
        label.textColor = .white
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()

    let infoCard = PokemonInfoView()

    let photoCarousel = PhotoCarousel()

    let photoIndicator = PhotoIndicator()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Helpers

    private func setupViews() {
        addSubview(pokemonNameLabel)
        addSubview(idLabel)
        addSubview(typeLabel)

        pokemonNameLabel.anchor(
            top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: idLabel.leadingAnchor, padding: UIEdgeInsets(top: 90, left: 20, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 0))

        idLabel.anchor(
            top: self.topAnchor, leading: pokemonNameLabel.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 20),
            size: CGSize(width: 60, height: 50))

        typeLabel.anchor(
            top: pokemonNameLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0),
            size: CGSize(width: 70, height: 0))

        addSubview(infoCard)
        infoCard.anchor(
            top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 0, height: self.frame.height / 2))

        setupPhotoCarousel()
    }

    private func setupPhotoCarousel() {

        addSubview(photoCarousel)
        photoCarousel.anchor(
            top: nil, leading: nil, bottom: infoCard.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0), size: CGSize(width: 230, height: 230))
        photoCarousel.centerXInSuperview()

        addSubview(photoIndicator)
        photoIndicator.anchor(
            top: photoCarousel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 131, bottom: 0, right: 131),
            size: CGSize(width: 0, height: 28))
    }
}
