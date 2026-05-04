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
    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    private let viewRegister = RegisterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Eye Button Helper
    private func addPasswordToggle(to textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemBlue
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
        button.center = CGPoint(x: 16, y: 20)
        container.addSubview(button)

        textField.rightView = container  // ← container, NO button
        textField.rightViewMode = .always
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        // Determina cuál textField le pertenece el botón
        let targetField: UITextField?
        if sender === tfPassword.rightView {
            targetField = tfPassword
        } else {
            targetField = tfConfirmPassword
        }
        
        guard let field = targetField else { return }
        field.isSecureTextEntry.toggle()
        
        // Fix para que el cursor no salte
        if let text = field.text {
            field.text = nil
            field.insertText(text)
        }
    }
    private func setupCardView() {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.12
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(card, at: 0)

        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    
            card.topAnchor.constraint(equalTo: lblTitle.topAnchor, constant: -12),
            
            card.bottomAnchor.constraint(equalTo: btnRegister.bottomAnchor, constant: 20)
        ])
    }
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
        addPasswordToggle(to: tfPassword)
        addPasswordToggle(to: tfConfirmPassword)
        
        
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
                guard let self = self else { return }
                self.updateFieldState(textField: self.tfUser,
                                     label: self.lblUserError,
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
        
        // Solo mostramos el error si es inválido Y el usuario ya escribió algo
        let shouldShowError = !isValid && !(textField.text?.isEmpty ?? true)
        
        label.isHidden = !shouldShowError
        
        if !shouldShowError {
            // Estado normal: Sin bordes
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
        } else {
            // Estado de error: Borde rojo
            textField.layer.borderWidth = 1.0
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
            
            // Guardar en UserDefaults
            viewRegister.saveToUserDefaults()
            
            // Mostrar alert de éxito y regresar al login
            let alert = UIAlertController(
                title: "¡Registro exitoso!",
                message: "Tu cuenta ha sido creada correctamente.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
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
        
        // 1. Calculamos el texto exacto que resultará después del cambio
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        // 2. Asignamos el valor al modelo y disparamos su validación específica
        switch textField {
        case tfUser:
            viewRegister.user.userName = updatedText
            viewRegister.validateUser()
            
        case tfName:
            viewRegister.user.name = updatedText
            viewRegister.validateName()
            
        case tfLastName:
            viewRegister.user.lastName = updatedText
            viewRegister.validateLastName()
            
        case tfPassword:
            viewRegister.user.password = updatedText
            viewRegister.validatePassword()
            // CRÍTICO: Si cambio el password, debo re-validar que el de confirmar coincida
            viewRegister.validateConfirmPassword()
            
        case tfConfirmPassword:
            viewRegister.user.confirmPassword = updatedText
            viewRegister.validateConfirmPassword()
            
        default:
            break
        }
        
        // 3. Validamos el estado general del botón
        viewRegister.validateForm()
        
        return true
    }
}
