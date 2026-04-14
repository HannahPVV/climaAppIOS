//
//  HomeViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 25/03/26.
//


import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var lblUserError: UILabel!
    @IBOutlet weak var lblNameError: UILabel!
    @IBOutlet weak var lblLastNameError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    

    
   
    
    
    
    
    private let viewRegister = RegisterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfPassword.isSecureTextEntry = true
        tfConfirmPassword.isSecureTextEntry = true
        
        tfUser.delegate = self
        tfName.delegate = self
        tfLastName.delegate = self
        tfPassword.delegate = self
        tfConfirmPassword.delegate = self
        
        hideErrorLabels()
        setupBindings()
        setupTapGesture()
        
        btnRegister.isEnabled = false
        btnRegister.alpha = 0.5
    }
    
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: view,
                                               action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func hideErrorLabels() {
        lblUserError.isHidden = true
        lblNameError.isHidden = true
        lblLastNameError.isHidden = true
        lblPasswordError.isHidden = true
        lblConfirmPasswordError.isHidden = true
    }
    
    func setupBindings() {
        viewRegister.$isValidForm
            .sink { [weak self] isValid in
                guard let self else { return }
                self.btnRegister.isEnabled = isValid
                self.btnRegister.alpha = isValid ? 1.0 : 0.5
            }
            .store(in: &cancellables)
        
        viewRegister.$isUserValid
            .combineLatest(viewRegister.$userErrorMessage)
            .sink { [weak self] isValid, message in
                guard let self else { return }
                self.updateFieldState(textField: self.tfUser, label: self.lblUserError,
    
                isValid: isValid,
                                      message: message)
            }
            .store(in: &cancellables)
        
        viewRegister.$isNameValid
            .combineLatest(viewRegister.$nameErrorMessage)
            .sink { [weak self] isValid, message in
                guard let self else { return }
                self.updateFieldState(textField: self.tfName,
                                      label: self.lblNameError,
                                      isValid: isValid,
                                      message: message)
            }
            .store(in: &cancellables)
        
        viewRegister.$isLastNameValid
            .combineLatest(viewRegister.$lastNameErrorMessage)
            .sink { [weak self] isValid, message in
                guard let self else { return }
                self.updateFieldState(textField: self.tfLastName,
                                      label: self.lblLastNameError,
                                      isValid: isValid,
                                      message: message)
            }
            .store(in: &cancellables)
        
        viewRegister.$isPasswordValid
            .combineLatest(viewRegister.$passwordErrorMessage)
            .sink { [weak self] isValid, message in
                guard let self else { return }
                self.updateFieldState(textField: self.tfPassword,
                                      label: self.lblPasswordError,
                                      isValid: isValid,
                                      message: message)
            }
            .store(in: &cancellables)
        
        viewRegister.$isConfirmPasswordValid
            .combineLatest(viewRegister.$confirmPasswordErrorMessage)
            .sink { [weak self] isValid, message in
                guard let self else { return }
                self.updateFieldState(textField: self.tfConfirmPassword,
                                      label: self.lblConfirmPasswordError,
                                      isValid: isValid,
                                      message: message)
            }
            .store(in: &cancellables)
    }
    
    func updateFieldState(textField: UITextField,
                          label: UILabel,
                          isValid: Bool,
                          message: String) {
        label.text = message
        label.isHidden = isValid
        
        if isValid {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
        } else {
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        view.endEditing(true)
        viewRegister.validateForm()
        
        guard viewRegister.isValidForm else { return }
        
        btnRegister.isEnabled = false
        btnRegister.alpha = 0.5
        
        print("Registro correcto")
        
        // Aquí luego puedes guardar o enviar datos
    }
    
    @IBAction func popViewController() {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if textField == tfUser {
            viewRegister.user.userName = updatedText
            viewRegister.validateUser()
            
        } else if textField == tfName {
            viewRegister.user.name = updatedText
            viewRegister.validateName()
            
        } else if textField == tfLastName {
            viewRegister.user.lastName = updatedText
            viewRegister.validateLastName()
            
        } else if textField == tfPassword {
            viewRegister.user.password = updatedText
            viewRegister.validatePassword()
            viewRegister.validateConfirmPassword()
            
        } else if textField == tfConfirmPassword {
            viewRegister.user.confirmPassword = updatedText
            viewRegister.validateConfirmPassword()
        }
        
        viewRegister.validateForm()
        return true
    }
}
