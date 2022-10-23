//
//  PokemonTableViewController.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import UIKit

class PokemonTableViewController: UIViewController {
    private let viewModel: PokemonTableModelView
      
      private let tableView = UITableView()
    
      private var data: Page?
      
      init(viewModel: PokemonTableModelView) {
          self.viewModel = viewModel
          super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           viewModel.ready()
       }
    private func setupViewModel() {
        viewModel.isRefreshed.bind({ (isRefreshed) in
            
            self.data = self.viewModel.repos
        })
    }
}
