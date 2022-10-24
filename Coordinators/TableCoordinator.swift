//
//  TableCoorinator.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import UIKit

class TableCoordinator: Coordinator {
    func start() {
        showTable()
    }
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func showTable(){
        let viewModel = PokemonTableModelView(networkingService: NetworkingApi())
        let viewController = PokemonTableViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    func showDetail(details: PokemonTable) {
        let vc = PokemonDetailsViewController()
        let viewModel = PokemonDetailsModelView(networkingService: NetworkingDetailsApi())
        viewModel.detailsPokemon = details
        viewModel.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
