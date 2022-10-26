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
    var networkStatus = Dynamic(false)
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NSNotification.Name.connectivityStatus.rawValue),
                                               object: nil,
                                               queue: nil,
                                               using:catchNotificationNetwork)
        let queueConc = DispatchQueue(label: "json1", attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        queueConc.async { [self] in
            if let savedPerson = defaults.object(forKey: "https://pokeapi.co/api/v2/pokemon") as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(Page.self, from: savedPerson) {
                    finishSearching(with: loadedPerson)
                    group.leave()
                    //                print(loadedPerson.results)
                }
            }
        }
        group.enter()
        if NetworkMonitor.shared.isConnected{
            queueConc.async {
                self.networkingService.loadDataPage(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!) { data, error in
                    if data != nil{
                        self.finishSearching(with: data!)
                    }
                }
                group.leave()
            }
        }
    }
    func next() {
        
        isRefreshedPage.value = false
        isRefreshing?(true)
        let urlString = (repos?.next?.absoluteString)
        let queueConc = DispatchQueue(label: "json", attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        queueConc.async { [self] in
            if let savedPerson = defaults.object(forKey: urlString ?? "https://pokeapi.co/api/v2/pokemon") as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(Page.self, from: savedPerson) {
                    finishSearchingPage(with: loadedPerson)
                    group.leave()
                    //                print(loadedPerson.results)
                }
            }
            else{
                if NetworkMonitor.shared.isConnected{
                    group.enter()
                    queueConc.async {
                        self.networkingService.loadDataPage(url: (self.repos?.next) ?? URL(string: "https://pokeapi.co/api/v2/pokemon")!  ) { [self] data, error in
                            if data != nil{
                                self.finishSearchingPage(with: data!)
                            }
                        }
                        group.leave()
                    }
                }
            }
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
    func catchNotificationNetwork(notification:Notification) -> Void {
        networkStatus.value = NetworkMonitor.shared.isConnected
    }
}
