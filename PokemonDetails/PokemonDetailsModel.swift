//
//  PokemonModel.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import Foundation
struct PokemonDetails:Codable{
    let name:String?
    let height:Int?
    let weight:Int?
    let sprites: Sprites?
    let types: [Types]?
}
struct Sprites:Codable{
    let front_shiny:URL?
}
struct Types:Codable{
    let slot:Int?
    let type: Typeone?
}
struct Typeone:Codable{
    let name: String?
    let url: URL?
}
