//
//  MainViewModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 20/03/26.
//

import Combine

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
    
    func validateForm() {
        print("User \(user)")
        isValidForm = !(user.userName.isEmpty || user.password.isEmpty)
        print("isValid: \(isValidForm)")
        
        isUserValid = !user.userName.isEmpty
        isPasswordValid = !user.password.isEmpty

    }
    
    func validateUser(){
       
    }
    
    func validatePassword(){
        
    }
}
