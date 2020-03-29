//
//  IndicatorCell.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

/// Cell to be used as indicator for photo cell being presented in PhotoCarousel.
///
/// Similar to UIPageControl in appearence.
class IndicatorCell: BaseCell {
    
    // MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let indicatorView: UIView = {
        let iv = UIView()
        iv.layer.cornerRadius = 4
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
    }()
    
    override var isSelected: Bool {
        didSet {
            indicatorView.backgroundColor = isSelected ? .black : .lightGray
        }
    }
    
    // MARK: - Helpers
    
    override func setupViews() {
        super.setupViews()
        
        isUserInteractionEnabled = false
        
        addSubview(indicatorView)
        indicatorView.constrainHeight(constant: 8)
        indicatorView.constrainWidth(constant: 8)
        indicatorView.centerInSuperview()
    }
}
