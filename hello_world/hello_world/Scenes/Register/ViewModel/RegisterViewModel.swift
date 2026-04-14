//
//  RegisterViewModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 25/03/26.
//

import Combine
import Foundation

class RegisterViewModel {
    
    var model: RegisterModel = .init()
    
    @Published var isValidForm: Bool = false
    @Published var isUserValid: Bool = true
    @Published var isNameValid: Bool = true
    @Published var isLastNameValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    @Published var userErrorMessage: String = ""
    @Published var nameErrorMessage: String = ""
    @Published var lastNameErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    
    
    var user: User {
        get {
            return model.user
        }
        set {
            model.user = newValue
        }
    }
    
    func validateUser() {
        let value = user.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if value.isEmpty {
            isUserValid = false
            userErrorMessage = "El usuario es obligatorio"
        } else {
            isUserValid = true
            userErrorMessage = ""
        }
    }
    
    func validateName() {
        let value = user.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if value.isEmpty {
            isNameValid = false
            nameErrorMessage = "El nombre es obligatorio"
        } else {
            isNameValid = true
            nameErrorMessage = ""
        }
    }
    
    func validateLastName() {
        let value = user.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if value.isEmpty {
            isLastNameValid = false
            lastNameErrorMessage = "El apellido es obligatorio"
        } else {
            isLastNameValid = true
            lastNameErrorMessage = ""
        }
    }
    
    
    func validatePassword() {
        let value = user.password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if value.isEmpty {
            isPasswordValid = false
            passwordErrorMessage = "La contraseña es obligatoria"
        } else if value.count < 6 {
            isPasswordValid = false
            passwordErrorMessage = "Mínimo 6 caracteres"
        } else {
            isPasswordValid = true
            passwordErrorMessage = ""
        }
    }
    
    func validateConfirmPassword() {
        let value = user.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if value.isEmpty {
            isConfirmPasswordValid = false
            confirmPasswordErrorMessage = "Confirma la contraseña"
        } else if value != user.password {
            isConfirmPasswordValid = false
            confirmPasswordErrorMessage = "No coinciden"
        } else {
            isConfirmPasswordValid = true
            confirmPasswordErrorMessage = ""
        }
    }
    
    func validateForm() {
        validateUser()
        validateName()
        validateLastName()
        validatePassword()
        validateConfirmPassword()
        
        isValidForm = isUserValid && isNameValid && isLastNameValid && isPasswordValid && isConfirmPasswordValid
    }
}
