//
//  HomeViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/03/26.
//


import UIKit

class HomeViewController:UITabBarController{
    
    
    //MARK: -Propiedades privadas
    private let viewModel:HomeViewModel
    
    init?(coder:NSCoder,viewModel:HomeViewModel){
        self.viewModel = viewModel
        super.init(coder:coder)
    }
    
    required init?(coder:NSCoder){
        fatalError("init coder has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false) //ocultar botton
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}
