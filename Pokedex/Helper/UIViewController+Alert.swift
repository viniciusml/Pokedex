//
//  UIViewController+Alert.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

extension UIViewController {

    ///Displays alert to handle possible issues to the user.
    func showBasicAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}

public protocol AlertPresenter {
    func presentAlert(title: String, message: String)
}

class AlertErrorPresenter: AlertPresenter {

    let controller: UIViewController

    init(_ controller: UIViewController) {
        self.controller = controller
    }

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        controller.present(alert, animated: true)
    }
}
