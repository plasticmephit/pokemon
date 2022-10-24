//
//  PokemonTableModelView.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import Foundation
class PokemonTableModelView {
    var isRefreshing: ((Bool) -> Void)?
    var isRefreshed = Dynamic(false)
    var isRefreshedPage = Dynamic(false)
    var didUpdateRepos: ((Page) -> Void)?
    var didSelecteRepo: ((String) -> Void)?
    var repos:Page?
    var coordinator: TableCoordinator?
    
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func ready() {
        isRefreshing?(true)
        let queueConc = DispatchQueue(label: "json", attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        queueConc.async {
            self.networkingService.loadDataPage(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!) { data, error in
                self.finishSearching(with: data!)
            }
            group.leave()
        }
        
    }
    func next() {
        isRefreshedPage.value = false
        isRefreshing?(true)
        let queueConc = DispatchQueue(label: "json", attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        queueConc.async {
            print (self.repos?.next)
            self.networkingService.loadDataPage(url: (self.repos?.next) ?? URL(string: "https://pokeapi.co/api/v2/pokemon")!  ) { data, error in
                self.finishSearchingPage(with: data!)
            }
            group.leave()
        }
        
    }
    private func finishSearchingPage(with repos: Page) {
        isRefreshing?(false)
        self.repos = repos
        
        isRefreshedPage.value = true
    }
    private func finishSearching(with repos: Page) {
        isRefreshing?(false)
        self.repos = repos
        isRefreshed.value = true
    }
    
    func didSelectRow(at pokemon: PokemonTable) {
        coordinator?.showDetail(details: pokemon)
    }
}
