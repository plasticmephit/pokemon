//
//  PokemonModel.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import Foundation
struct PokemonDetails:Decodable{
    let name:String?
    let height:Int?
    let weight:Int?
    let sprites: Sprites?
    let types:[Types]
}
struct Sprites:Decodable{
    let front_shiny:URL
}
struct Types:Decodable{
    let name:String?
    let url: URL?
}
