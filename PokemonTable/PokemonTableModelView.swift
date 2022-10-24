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
            self.networkingService.loadDataPage { data, error in
                self.finishSearching(with: data!)
            }
            group.leave()
        }
        
    }
    
    private func finishSearching(with repos: Page) {
           isRefreshing?(false)
        self.repos = repos
           isRefreshed.value = true
        
       }
    
    func didSelectRow(at indexPath: IndexPath) {
        coordinator?.showDetail(details: (repos?.results![indexPath.row])!)
       }
}
