//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class PokemonInfoView: UIView {

    //    MARK: - Properties

    var abilitiesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Abilities"
        label.font = UIFont(name: Font.medium, size: 20)!
        return label
    }()

    var abilitiesValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Font.medium, size: 16)!
        label.textColor = .darkGray
        return label
    }()

    var statsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stats"
        label.font = UIFont(name: Font.medium, size: 20)!
        return label
    }()

    var statsValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Font.medium, size: 16)!
        label.textColor = .darkGray
        return label
    }()

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
        backgroundColor = .white
        layer.cornerRadius = 15

        let verticalStack = VerticalStackView(arrangedSubviews: [statsTitleLabel, statsValueLabel, abilitiesTitleLabel, abilitiesValueLabel])
        verticalStack.distribution = .fillEqually

        addSubview(verticalStack)
        verticalStack.fillSuperview(padding: UIEdgeInsets(top: 40, left: 20, bottom: 100, right: 20))
    }

    func renderUI(with pokemon: PokemonItem) {
        statsValueLabel.text = pokemon.stats.map { $0.stat.name }.joined(separator: ", ").capitalized
        abilitiesValueLabel.text = pokemon.abilities.map { $0.ability.name }.joined(separator: ", ").capitalized
    }
}
