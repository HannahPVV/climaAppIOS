//
//  ViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 13/03/26.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    //MARK: - Componentes visuales
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblUserError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var cardView: UIVIew!
    
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
    }
    
    //Usar en storyboard y Outlet es componente
    @IBAction func loginTapped() {
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
