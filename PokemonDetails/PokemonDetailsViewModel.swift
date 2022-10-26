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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NSNotification.Name.connectivityStatus.rawValue),
                                               object: nil,
                                               queue: nil,
                                               using:catchNotificationNetwork)
        let queueConc = DispatchQueue(label: "json", attributes: .concurrent)
        let group = DispatchGroup()
        if NetworkMonitor.shared.isConnected{
            group.enter()
            queueConc.async { [self] in
                networkingService.loadDataDetails(url: (detailsPokemon?.url)!)
                { data, error in
                    if data != nil{
                        self.finishSearching(with: data!)
                    }
                }
                group.leave()
            }
        }
    }
    
    private func finishSearching(with repos: PokemonDetails) {
           isRefreshing?(false)
        self.repos = repos
           isRefreshed.value = true
       }
    func catchNotificationNetwork(notification:Notification) -> Void {
        ready()
    }
}
