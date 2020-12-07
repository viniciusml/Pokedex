//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class PokemonViewController: UIViewController {

    // MARK: - Properties

    let viewModel: PokemonViewModel
    
    let mainView = PokemonMainView()

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
        
        observeViewModel()
        viewModel.fetchPokemon()
    }
    
    private func observeViewModel() {
        viewModel.onFetchCompleted = { [weak self] pokemon in
            self?.mainView.renderUI(with: pokemon)
        }
        
        viewModel.onFetchFailed = { [weak self] errorMessage in
            self?.showBasicAlert(title: "Error", message: errorMessage)
        }
    }
}
