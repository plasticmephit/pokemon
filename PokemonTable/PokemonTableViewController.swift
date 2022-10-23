//
//  PokemonTableViewController.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import UIKit
import SnapKit
class PokemonTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.results?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = data?.results?[indexPath.row].name
        return cell
    }
    
    private let viewModel: PokemonTableModelView
    
    let tableView: UITableView = .init()
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.ready()
    }
    private func setupViewModel() {
        viewModel.isRefreshed.bind({ (isRefreshed) in
            self.data = self.viewModel.repos
            DispatchQueue.main.async { [self] in
                self.tableView.reloadData()
            }
        })
    }
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
