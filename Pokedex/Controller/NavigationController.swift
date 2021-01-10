//
//  NavigationController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 10/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        
        configure()
    }
    
    private func configure() {
        //Set Navigation bar transparent
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .tintColor
        
        //Set text from back button transparent
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setForegroundColor(.clear, for: [.normal, .highlighted])
        
        //Set title color and font
        navigationBar.setTitleTextAttributes([
            .font: UIFont(name: Font.bold, size: 20)!,
            .foregroundColor: UIColor.tintColor,
            .kern: NSNumber(floatLiteral: 1.3),
        ])
    }
}

private extension UIBarButtonItem {
    func setForegroundColor(_ color: UIColor, for states: [UIControl.State]) {
        states.forEach { setTitleTextAttributes([.foregroundColor: color], for: $0) }
    }
}

private extension UINavigationBar {
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        titleTextAttributes = attributes
    }
}
