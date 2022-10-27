//
//  PokemonTableViewController.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import UIKit
import SnapKit
import PaginatedTableView
import SystemConfiguration
class PokemonTableViewController: UIViewController, PaginatedTableViewDelegate, PaginatedTableViewDataSource {
    
    private let viewModel: PokemonTableModelView
    private var pokemons: [PokemonTable]?
    
    let refreshControl = UIRefreshControl()
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
        tableView.enablePullToRefresh = false
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
          refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
          tableView.addSubview(refreshControl)
        setupView()
        setupViewModel()
        viewModel.ready()
        alert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    private func setupViewModel() {
        viewModel.isRefreshed.bind({ (isRefreshed) in
            if isRefreshed{
                self.pokemons = self.viewModel.repos?.results
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.alpha = 0
//        UIView.animate(
//            withDuration: 0.05,
//            delay: 0.05 * Double(indexPath.row),
//            animations: {
//                cell.alpha = 1
//        })
    }
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        viewModel.next()
        pagination()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            onSuccess?(true)
        }
    }
}

extension PokemonTableViewController{
    func setupView(){
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.text = "Pokemons"
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .white
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
    func pagination(){
        viewModel.isRefreshedPage.bind({ [self] (isRefreshed) in
            if pokemons != nil {
                if pokemons![pokemons!.count-1].name != viewModel.repos?.results?[(viewModel.repos?.results!.count)!-1].name{
                    for number in 0...(self.viewModel.repos?.results!.count)!-1 {
                        self.pokemons?.append((self.viewModel.repos?.results?[number])!)
                    }
                }
            }
        })
    }
    @objc func refresh(_ sender: AnyObject) {
        pokemons = nil
        viewModel.refresh()
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
      
    }
    func alert(){
        viewModel.networkStatus.bind({ [self] (networkStatus) in
            print(networkStatus)
            if networkStatus == false{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Internet Connection", message: "Lost", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                 
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                if pokemons == nil{
                    viewModel.ready()
                }
            }
        })
    }
}
