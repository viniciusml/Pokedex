//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public final class PokemonViewController: UIViewController {

    // MARK: - Properties

    let viewModel: PokemonViewModel
    
    let mainView = PokemonMainView()
    
    let photoCarousel = PageViewController(transitionStyle: .scroll)
    var imageControllers = [PokemonImageViewController]() {
        didSet { renderImages() }
    }

    // MARK: - Initializer

    public init(viewModel: PokemonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    public override func loadView() {
        view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCarousel()
        observeViewModel()
        viewModel.fetchPokemon()
    }
    
    func configureCarousel() {
        addChild(photoCarousel)
        mainView.setupPhotoCarousel(photoCarousel.view)
    }
    
    private func observeViewModel() {
        viewModel.onFetchCompleted = { [weak self] viewModel in
            self?.renderUI(with: viewModel)
        }
        
        viewModel.onFetchFailed = { [weak self] in
            self?.showBasicAlert(title: "Error", message: "An error ocurred. Please try again")
        }
    }
    
    private func renderUI(with viewModel: PokemonViewModel) {
        mainView.pokemonNameLabel.text = viewModel.name
        mainView.idLabel.text = viewModel.id
        mainView.idLabel.accessibilityLabel = "Id: \(viewModel.id?.replacingOccurrences(of: "#", with: "") ?? "")"
        
        mainView.backgroundColor = viewModel.backgroundColor?.toUIColor
        mainView.typeLabel.text = viewModel.type
        mainView.typeLabel.accessibilityLabel = "Type: \(viewModel.type ?? "")"
        
        mainView.infoCard.statsValueLabel.text = viewModel.stats
        mainView.infoCard.abilitiesValueLabel.text = viewModel.abilities
    }
    
    private func renderImages() {
        photoCarousel.setPages(imageControllers)
    }
}
