//
//  PokemonDetailsViewController.swift
//  pokemon
//
//  Created by Maksimilian on 24.10.22.
//

import UIKit
import Kingfisher
class PokemonDetailsViewController: UIViewController {
    
    let name : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/35)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
   
    let height : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/35)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    let type : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/35)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    let weight : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/35)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    var avatar = UIImageView()
    
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
        setupview()
        setupViewModel()
        viewModel.ready()
        // Do any additional setup after loading the view.
    }
}
extension PokemonDetailsViewController {
    func setupview(){

        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.text = viewModel.detailsPokemon?.name
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .white
        view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        view.addSubview(name)
        name.snp.makeConstraints { make in
            make.bottom.equalTo(avatar.snp.top).inset(20)
            make.centerX.equalToSuperview()
        }
        view.addSubview(height)
        height.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(20)
            make.left.equalTo(avatar.snp.left).inset(10)
        }
        view.addSubview(weight)
        weight.snp.makeConstraints { make in
            make.top.equalTo(height.snp.bottom).offset(20)
            make.left.equalTo(avatar.snp.left).inset(10)
        }
        view.addSubview(type)
        type.snp.makeConstraints { make in
            make.top.equalTo(weight.snp.bottom).offset(20)
            make.left.equalTo(avatar.snp.left).inset(10)
        }
    }
    private func setupViewModel() {
        viewModel.isRefreshed.bind({ (isRefreshed) in
           if isRefreshed{
                self.data = self.viewModel.repos
                DispatchQueue.main.async { [self] in
//                    name.text = data?.name
                    var types:String = ""
                    for num in 0...(data?.types!.count)!-1{
                        if  data?.types![num].type?.name != nil{
                            types =  types + String(((data?.types![num].type?.name)!)) + " and "
                        }
                    }
                    types.removeLast(4)
                    type.text = "types: " + types
                    weight.text = "weight: " + String(((data?.weight)!))
                    height.text = "height: " + String((data?.height)!)
                    avatar.kf.setImage(with: data?.sprites?.front_shiny)
                    UIView.animate(withDuration: 0.4) {
                            self.view.layoutIfNeeded()
                    }
                }
            }
        })
    }
}
