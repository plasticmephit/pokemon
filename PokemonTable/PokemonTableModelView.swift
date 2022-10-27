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
        isRefreshed.value = false
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NSNotification.Name.connectivityStatus.rawValue),
                                               object: nil,
                                               queue: nil,
                                               using:catchNotificationNetwork)
       loadvalues(url: "https://pokeapi.co/api/v2/pokemon", refrashing: isRefreshed)
    }
    func refresh(){
        repos = nil
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        ready()
    }
    
    func next() {
        isRefreshedPage.value = false
        isRefreshing?(true)
        let urlString = (repos?.next?.absoluteString)
        loadvalues(url: urlString ?? "https://pokeapi.co/api/v2/pokemon", refrashing: isRefreshedPage)
    }
    private func finishSearching(with repos: Page, refrashing: Dynamic<Bool>) {
        isRefreshing?(false)
        self.repos = repos
        
        refrashing.value = true
    }
    
    func loadvalues(url: String, refrashing: Dynamic<Bool>){
        let queueConc = DispatchQueue(label: "json1", attributes: .concurrent)
        let group = DispatchGroup()
        group.enter()
        queueConc.async { [self] in
            if let savedPerson = defaults.object(forKey: url) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(Page.self, from: savedPerson) {
                    finishSearching(with: loadedPerson, refrashing: refrashing)
                    group.leave()
                    //                print(loadedPerson.results)
                }
            }
            else{
                if NetworkMonitor.shared.isConnected{
                   
                        self.networkingService.loadDataPage(url: URL(string: url)!  ) { [self] data, error in
                            if data != nil{
                                self.finishSearching(with: data!, refrashing: refrashing)
                            }
                            group.leave()
                    }
                }
            }
        }
    }
    func didSelectRow(at pokemon: PokemonTable) {
        coordinator?.showDetail(details: pokemon)
    }
    func catchNotificationNetwork(notification:Notification) -> Void {
        networkStatus.value = NetworkMonitor.shared.isConnected
    }
}
