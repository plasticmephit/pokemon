//
//  PokemonDetailsNetwork.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//
import Foundation
protocol NetworkingDetailsService {
    func loadDataDetails(completion: @escaping (_ data: PokemonDetails?, _ error: Error?) -> Void)
}

final class NetworkingDetailsApi: NetworkingDetailsService {
    func loadDataDetails(completion: @escaping (_ data: PokemonDetails?, _ error: Error?) -> Void) {
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            do {
                if let data = data {
                    let json = try JSONDecoder().decode(PokemonDetails.self, from: data)
                    completion(json, nil)
                    
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        })
        task.resume()
    }
}

