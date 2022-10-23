//
//  PokemonTableModel.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import Foundation
import UIKit
struct Page: Decodable
{
    let count:Int?
    let next: URL?
    let previous: URL?
    let results:[PokemonTable]?
}

struct PokemonTable:Decodable
{
    let name:String?
    let url: URL?
}
