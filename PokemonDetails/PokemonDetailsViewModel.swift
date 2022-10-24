//
//  PokemonViewModel.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import Foundation
class PokemonDetailsModelView {
    var isRefreshing: ((Bool) -> Void)?
    var isRefreshed = Dynamic(false)
    var didUpdateRepos: ((Page) -> Void)?
    var repos:PokemonDetails?
    var detailsPokemon:PokemonTable?
    var coordinator: TableCoordinator?
    private let networkingService: NetworkingDetailsService
        
        init(networkingService: NetworkingDetailsService) {
            self.networkingService = networkingService
        }
    
    func ready() {
        isRefreshing?(true)
        let queueConc = DispatchQueue(label: "json", attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        queueConc.async {
            self.networkingService.loadDataDetails
            { data, error in
                self.finishSearching(with: data!)
            }
            group.leave()
        }
        
    }
    
    private func finishSearching(with repos: PokemonDetails) {
           isRefreshing?(false)
        self.repos = repos
           isRefreshed.value = true
        
       }
}
