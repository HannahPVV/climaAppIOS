//
//  ViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 13/03/26.
//

import UIKit
import Combine
import LocalAuthentication

class MainViewController: UIViewController {
    
    //MARK: - Componentes visuales
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblUserError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    
    //MARK: - Propiedades privadas
    private let viewModel = MainViewModel()
    private var cancellable = Set<AnyCancellable>()

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        tfPassword.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        
        tapGesture.cancelsTouchesInView = false // toques en la pantalla principal
        
        view.addGestureRecognizer(tapGesture)
        // Fin ocultar teclado
        
        tfUser.delegate = self
        tfPassword.delegate = self
        
        //PUBLISHER DEL OTRO LADO -> $
        viewModel.$isValidForm
        //Ejecutando en otra rama
            .sink{ [weak self] isValid in
                guard let self else { return }
                self.btnLogin.isEnabled = isValid
            }
            .store(in: &cancellable)
        
        viewModel.$isUserValid
            .sink { [weak self] isValid in
                guard let self else { return }
                self.setErrorBorder(for: self.tfUser, show: !isValid)
            }
            .store(in: &cancellable)
        
        viewModel.$isPasswordValid
            .sink { [weak self] isValid in
                guard let self else { return }
                self.setErrorBorder(for: self.tfPassword, show: !isValid)
            }
            .store(in: &cancellable)
        
        let defaults = UserDefaults.standard
        if let savedName = defaults.string(forKey: "name"), !savedName.isEmpty {
            lblWelcome.text = "Bienvenido, \(savedName)"
        } else {
            lblWelcome.text = "Bienvenido"
        }
    }
    
    //Usar en storyboard y Outlet es componente
    @IBAction func loginTapped() {
        viewModel.validateForm()
        guard viewModel.isValidForm else {
            setErrorBorder(for: tfUser, show: !viewModel.isUserValid)
            setErrorBorder(for: tfPassword, show: !viewModel.isPasswordValid)
            return
        }
        //Validamos si existe o no
        guard let navigationController = navigationController else { return }
        let storyBoardName = "Main"
        let id = "Home"
        
        //Bundle dice en que proyecto esta
        let secondVC = UIStoryboard(
            name: storyBoardName,
            bundle: nil
        ).instantiateViewController(identifier: id) { coder in
            self.viewModel.user.name = "Hannah Valencia"
            let model = HomeModel(user: self.viewModel.user)
            let viewModel = HomeViewModel(model: model)
            return HomeViewController(coder: coder, viewModel: viewModel)
        }
        
        navigationController.pushViewController(secondVC, animated: true)
        //navigationController.present(secondVC, animated: true)
    }
    
    @IBAction func faceIDTapped() {
            let context = LAContext() // Crea un contexto de autenticación biométrica
            var error: NSError? = nil // Variable para capturar posibles errores durante la evaluación

            // Verifica si el dispositivo puede usar autenticación biométrica (Face ID / Touch ID)
            let canUseBiometrics = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            if canUseBiometrics {
                let reason = "Please authorize with Face ID" // Mensaje que se mostrará al usuario al solicitar autenticación

                // Inicia la evaluación biométrica (Face ID / Touch ID)
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                    DispatchQueue.main.async { // Asegura que cualquier actualización de UI se haga en el hilo principal
                        guard let self else { return }

                        if success {
                            // Autenticación exitosa
                            // Puedes continuar con acciones protegidas o mostrar datos sensibles
                            print("Biometric authentication successful")
                            self.loginTapped() // Navegación al home view controller
                        }
                        else if let error = error {
                            // Manejar fallo de autenticación o errores
                            // Por ejemplo, mostrar un mensaje de error al usuario
                            print("Biometric authentication failed with error: \(error.localizedDescription)")
                        }
                        else {
                            // La autenticación biométrica fue cancelada o falló
                            // Manejar el caso cuando el usuario cancela o falla la autenticación
                            print("Biometric authentication was canceled or failed")
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Oops...", message: "You can't use this feature", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok :(", style: .cancel, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true)
            }
        }// Se ejecuta cuando el usuario toca el botón de Face ID
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate { //Herencia
    //Opcional: Ocultar el teclado al presionar return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Quita el foco del textfield
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString
        string: String) -> Bool {
        //Calculamos el texto
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true } //Preguntamos si es diferente de nulo y si es lo guarda en range.
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        print("Nuevo texto: \(updatedText)")
        
        if tfUser == textField {
            viewModel.user.userName = updatedText
        }
        else if tfPassword == textField {
            viewModel.user.password = updatedText
        }
        viewModel.validateForm()
        
        return true
    }
    
    func setErrorBorder(for textField: UITextField, show: Bool) {
        if show {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
        } else {
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0.0
        }
    }
    
}


