//
//  PokemonTableModel.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import Foundation
import UIKit
struct Page: Codable
{
    let count:Int?
    var next: URL?
    var previous: URL?
    var results:[PokemonTable]?
}

struct PokemonTable:Codable
{
    let name:String?
    let url: URL?
}
