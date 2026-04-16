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
        // Usamos el valor directo, tal cual lo escribió el usuario
        let value = user.userName
        
        // 1. User Obligatorio
        if value.isEmpty {
            isUserValid = false
            userErrorMessage = "El usuario es obligatorio"
            return
        }
        
        // 2. No puede iniciar con número
        if let firstChar = value.first, firstChar.isNumber {
            isUserValid = false
            userErrorMessage = "No puede iniciar con número"
            return
        }
        
        // 3. Solo letras y números
        for caracter in value {
            // Si el caracter NO es letra Y TAMPOCO es número, lanzamos error
            if !caracter.isLetter && !caracter.isNumber {
                isUserValid = false
                userErrorMessage = "No se permiten espacios ni caracteres especiales"
                return
            }
        }
        
        // 4. Longitud de user
        if value.count < 4 || value.count > 20 {
            isUserValid = false
            userErrorMessage = "Debe tener entre 4 y 20 caracteres"
            return
        }
        
        // Si todo es correcto
        isUserValid = true
        userErrorMessage = ""
    }
    
    func validateName() {
        // Tomamos el valor tal cual lo escribió el usuario
        let value = user.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. REGLA: Obligatorio
        if value.isEmpty {
            isNameValid = false
            nameErrorMessage = "El nombre es obligatorio"
            return
        }
        
        // 2.Solo letras y espacios
        // Recorremos el nombre letra por letra
        for caracter in value {
            // Si no es una letra Y tampoco es un espacio, hay un error
            if !caracter.isLetter && !caracter.isWhitespace {
                isNameValid = false
                nameErrorMessage = "Solo se permiten letras"
                return
            }
        }
        
        // 3. Mínimo 2 caracteres
        if value.count < 2 {
            isNameValid = false
            nameErrorMessage = "Nombre demasiado corto"
            return
        }
        
        // 4. Máximo 30 caracteres
        if value.count > 30 {
            isNameValid = false
            nameErrorMessage = "Máximo 30 caracteres"
            return
        }
        
        // Si no entró en ningún 'if' anterior, el nombre está perfecto
        isNameValid = true
        nameErrorMessage = ""
    }
    
    func validateLastName() {
        // 1. Limpiamos espacios solo al inicio y al final
        let value = user.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2.  Apellido obligatorio
        if value.isEmpty {
            isLastNameValid = false
            lastNameErrorMessage = "El apellido es obligatorio"
            return
        }
        
        // 3.Solo letras y espacios (internos)
        for caracter in value {
            if !caracter.isLetter && !caracter.isWhitespace {
                isLastNameValid = false
                lastNameErrorMessage = "Solo se permiten letras"
                return
            }
        }
        
        // 4.Longitud (2 a 30 caracteres)
        if value.count < 2 {
            isLastNameValid = false
            lastNameErrorMessage = "Apellido demasiado corto"
            return
        }
        
        if value.count > 30 {
            isLastNameValid = false
            lastNameErrorMessage = "Máximo 30 caracteres"
            return
        }
        
        // Si todo sale bien
        isLastNameValid = true
        lastNameErrorMessage = ""
    }
    
    
    func validatePassword() {
        // Usamos el valor directo porque no permitimos espacios en ninguna parte
        let value = user.password
        
        // 1. REGLA: Obligatoria
        if value.isEmpty {
            isPasswordValid = false
            passwordErrorMessage = "La contraseña es obligatoria"
            return
        }
        
        // 2. REGLA: Sin espacios
        // Si detectamos cualquier espacio, lanzamos error
        if value.contains(" ") {
            isPasswordValid = false
            passwordErrorMessage = "No se permiten espacios"
            return
        }
        
        // 3. REGLA: Mínimo 8 caracteres
        if value.count < 8 {
            isPasswordValid = false
            passwordErrorMessage = "Debe tener al menos 8 caracteres"
            return
        }
        
        // 4. Mayúsculas, minúsculas y números
        // Creamos variables para saber si cumple con cada requisito, se usa $0 porque asi recorre cada letra
        let tieneMayuscula = value.contains { $0.isUppercase }
        let tieneMinuscula = value.contains { $0.isLowercase }
        let tieneNumero = value.contains { $0.isNumber }
        
        if !tieneMayuscula || !tieneMinuscula || !tieneNumero {
            isPasswordValid = false
            passwordErrorMessage = "Debe incluir mayúsculas, minúsculas y números"
            return
        }
        
        // Si pasa todas las reglas
        isPasswordValid = true
        passwordErrorMessage = ""
    }
    
    
    func validateConfirmPassword() {
    
        let value = user.confirmPassword
        
        // 1. Obligatoria
        if value.isEmpty {
            isConfirmPasswordValid = false
            confirmPasswordErrorMessage = "Debes confirmar la contraseña"
            return
        }
        
        // 2. Comparación exacta
        if value != user.password {
            isConfirmPasswordValid = false
            confirmPasswordErrorMessage = "Las contraseñas no coinciden"
            return
        }
        
        // Si pasó los filtros
        isConfirmPasswordValid = true
        confirmPasswordErrorMessage = ""
    }
    func validateForm() {
        validateUser()
        validateName()
        validateLastName()
        validatePassword()
        validateConfirmPassword()
        
        isValidForm = isUserValid && isNameValid && isLastNameValid && isPasswordValid && isConfirmPasswordValid
    }
    
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(user.name, forKey: "name")
        defaults.set(user.password, forKey: "password")
        defaults.set(user.userName, forKey: "userName")
    }
}
