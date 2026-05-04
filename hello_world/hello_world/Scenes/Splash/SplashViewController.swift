//
//  SplashViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 04/05/26.
//

import Foundation

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "lottie")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(animationView)
        animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            guard let navigationController = self.navigationController else { return }
            
            let storyboardName = "Main"
            let id = "Login" // cambia esto si tu login tiene otro Storyboard ID
            
            let loginVC = UIStoryboard(
                name: storyboardName,
                bundle: nil
            ).instantiateViewController(identifier: id)
            
            navigationController.pushViewController(loginVC, animated: true)
        }
    }
}
