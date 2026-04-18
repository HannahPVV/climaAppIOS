//
//  MainViewModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 20/03/26.
//

import Combine
import Foundation
class MainViewModel{
    
    var model: MainModel = .init()
    
    @Published var isValidForm: Bool = false
    @Published var isUserValid: Bool = true
    @Published var isPasswordValid: Bool = true
    
    var user: User{
        get {
            // do something
            return model.user
        }
        set {
            // var newValue: User
            model.user = newValue
        }
    }
    
    var isBiometricAuthenticated: Bool = false
    
    func validateForm() {
        print("User \(user)")
        
        let defaults = UserDefaults.standard
        let savedUserName = defaults.string(forKey: "userName") ?? ""
        let savedPassword = defaults.string(forKey: "password") ?? ""
        
        // Validaciones básicas
        isUserValid = !user.userName.isEmpty
        isPasswordValid = !user.password.isEmpty
        
        // Validar credenciales
        let credentialsMatch = user.userName == savedUserName && user.password == savedPassword
        
        // Validar si existe usuario registrado
        let hasRegisteredUser = !savedUserName.isEmpty
        
        // Aquí reemplazamos la lógica final
        isValidForm = ((isUserValid && isPasswordValid && credentialsMatch) ||
                      (isBiometricAuthenticated && hasRegisteredUser))
        
        print("isValid: \(isValidForm)")
    }

    
    
    func validateUser(){
       
    }
    
    func validatePassword(){
        
    }
}
