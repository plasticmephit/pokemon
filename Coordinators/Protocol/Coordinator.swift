//
//  Coordinator.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
