//
//  PokemonParser.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//
import Foundation
protocol NetworkingService {
    func loadDataPage(url: URL, completion: @escaping (_ data: Page?, _ error: Error?) -> Void)
}

final class NetworkingApi: NetworkingService {
    func loadDataPage(url: URL, completion: @escaping (_ data: Page?, _ error: Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            do {
                if let data = data {
                    let json = try JSONDecoder().decode(Page.self, from: data)
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

