//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    var id = ""
    
    var pokemonViewModel: PokemonViewModel!
    
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
    
    let photoCarousel = PhotoCarousel()
    
    let photoIndicator = PhotoIndicator()
    
    var infoCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
        
    convenience init(id: String) {
        self.init()
        self.id = id
        
        pokemonViewModel = PokemonViewModel(pokemonID: id, delegate: self)
        pokemonViewModel.fetchPokemon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupPhotoCarousel() {

        view.addSubview(photoCarousel)
        photoCarousel.anchor(top: nil, leading: nil, bottom: infoCard.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0), size: CGSize(width: 230, height: 230))
        photoCarousel.centerXInSuperview()
        
        view.addSubview(photoIndicator)
        photoIndicator.anchor(top: photoCarousel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 131, bottom: 0, right: 131), size: CGSize(width: 0, height: 28))
    }
    
    func setupViews() {
        view.addSubview(pokemonNameLabel)
        view.addSubview(idLabel)
        view.addSubview(typeLabel)
        
        pokemonNameLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: idLabel.leadingAnchor, padding: UIEdgeInsets(top: 90, left: 20, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        idLabel.anchor(top: view.topAnchor, leading: pokemonNameLabel.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 20), size: CGSize(width: 60, height: 50))
        
        typeLabel.anchor(top: pokemonNameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 50, height: 0))
        
        view.addSubview(infoCard)
        infoCard.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -30, right: 0), size: CGSize(width: 0, height: view.frame.height / 2))
        setupPhotoCarousel()
        
        let verticalStack = VerticalStackView(arrangedSubviews: [statsTitleLabel, statsValueLabel, abilitiesTitleLabel, abilitiesValueLabel])
        verticalStack.distribution = .fillEqually
        infoCard.addSubview(verticalStack)
        verticalStack.fillSuperview(padding: UIEdgeInsets(top: 40, left: 20, bottom: 100, right: 20))
    }
}

extension PokemonViewController: PokemonViewModelDelegate {
    
    func onFetchCompleted(pokemon: PokemonItem) {
        pokemonNameLabel.text = pokemon.name.capitalized
        idLabel.text = "#" + String(pokemon.id)
        
        if let type = pokemon.types.first {
            view.backgroundColor = type.typeID()?.color
            typeLabel.text = type.type.name.capitalized
        }
        
        statsValueLabel.text = pokemon.stats.map { $0.stat.name }.joined(separator: ", ").capitalized
        abilitiesValueLabel.text = pokemon.abilities.map { $0.ability.name }.joined(separator: ", ").capitalized
    }
    
    func onFetchFailed(with reason: String) {
        debugPrint("🛑⚠️ \(reason) ⚠️🛑")
    }
}
