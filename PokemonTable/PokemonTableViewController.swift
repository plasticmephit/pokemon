//
//  PokemonTableViewController.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import UIKit
import SnapKit
import PaginatedTableView
class PokemonTableViewController: UIViewController, PaginatedTableViewDelegate, PaginatedTableViewDataSource {
    
    private let viewModel: PokemonTableModelView
    
    //    private var data: Page?
    private var pokemons: [PokemonTable]?
    
    let tableView: PaginatedTableView = .init()
    
    init(viewModel: PokemonTableModelView) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        setupView()
        setupViewModel()
        viewModel.ready()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    private func setupViewModel() {
        viewModel.isRefreshed.bind({ (isRefreshed) in
            self.pokemons = self.viewModel.repos?.results
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        })
    }
}

extension PokemonTableViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = pokemons?[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.didSelectRow(at: (pokemons?[indexPath.row])!)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        viewModel.next()
        
            viewModel.isRefreshedPage.bind({ [self] (isRefreshed) in
                if pokemons![pokemons!.count-1].name != viewModel.repos?.results?[19].name{
                    for number in 0...(self.viewModel.repos?.results!.count)!-1 {
                        self.pokemons?.append((self.viewModel.repos?.results?[number])!)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    onSuccess?(true)
                }
            })
    }
}

extension PokemonTableViewController{
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints {
            make in
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
