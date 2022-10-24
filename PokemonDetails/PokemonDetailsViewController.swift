//
//  PokemonDetailsViewController.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    let name : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/35)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
   
    let mainNumber : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.435, green: 0.545, blue: 0.643, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    let address : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.435, green: 0.545, blue: 0.643, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 7
        return label
    }()
    
    var viewModel: PokemonDetailsModelView
  
    private var data: PokemonDetails?
    
    init(viewModel: PokemonDetailsModelView) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.ready()
        setupview()
        setupViewModel()
        // Do any additional setup after loading the view.
    }
}
extension PokemonDetailsViewController {
    func setupview(){
        view.backgroundColor = .white
        view.addSubview(name)
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(48)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    private func setupViewModel() {
        viewModel.isRefreshed.bind({ (isRefreshed) in
            self.data = self.viewModel.repos
            print(isRefreshed)
            DispatchQueue.main.async { [self] in
                name.text = data?.name
            }
        })
    }
}
