//
//  SignInViewController.swift
//  FindFriends
//
//  Created by Quan Tran on 25/10/2022.
//

import UIKit
import PromiseKit


class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupAlreadyHaveAccountButton()
        setupInputFields()
    }
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")!.withTintColor(.label,
                                                                    renderingMode: .alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        //button.backgroundColor = .red
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = .secondarySystemBackground
        tf.textColor = .label
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputchange), for: .editingChanged)
        return tf
    }()
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "firstName"
        tf.backgroundColor = .secondarySystemBackground
        tf.textColor = .label
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputchange), for: .editingChanged)
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "lastName"
        tf.backgroundColor = .secondarySystemBackground
        tf.textColor = .label
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputchange), for: .editingChanged)
        return tf
    }()
    
    let bioTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Bio"
        tf.backgroundColor = .secondarySystemBackground
        tf.textColor = .label
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputchange), for: .editingChanged)
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = .secondarySystemBackground
        tf.textColor = .label
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputchange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .systemGray2
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        button.setAttributedTitle(attributedTitle, for: .normal)
        attributedTitle.append(NSAttributedString(string: "Sign In.",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))

        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupAlreadyHaveAccountButton() {
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 50)
    }
    
    fileprivate func setupInputFields() {
        view.addSubview(photoButton)
        photoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackview = UIStackView(arrangedSubviews: [emailTextField, firstNameTextField, lastNameTextField, passwordTextField, bioTextField, signUpButton])
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.spacing = 10
        view.addSubview(stackview)
        
        stackview.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 250)
    }
    
    @objc
    func handleTextInputchange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && firstNameTextField.text?.count ?? 0 > 0
            && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemBlue
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .systemGray2
        }
    }

    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            photoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        photoButton.layer.cornerRadius = photoButton.frame.width / 2
        photoButton.layer.masksToBounds = true

        dismiss(animated: true, completion: nil)
    }
    
    
    @objc
    func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = firstNameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let bio = bioTextField.text, !bio.isEmpty else { return }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlertMissingInfor(from: .email)
            return
        }
        
        guard let avatarImage = photoButton.imageView?.image else {
            showAlertMissingInfor(from: .avatar)
            return
        }
        guard let firstName = firstNameTextField.text, !username.isEmpty else {
            showAlertMissingInfor(from: .firstName)
            return
        }
        guard let lastName = lastNameTextField.text, !username.isEmpty else {
            showAlertMissingInfor(from: .lastName)
            return
        }
        guard let password = passwordTextField.text, !username.isEmpty else {
            showAlertMissingInfor(from: .password)
            return
        }
        guard let bio = bioTextField.text, !username.isEmpty else {
            showAlertMissingInfor(from: .bio)
            return
        }
        
        firstly {
            AuthenticationService().uploadImage(image: avatarImage)
        }
        .then {
            AuthenticationService().registration(
                avatar: $0,
                email: email,
                firstName: firstName,
                lastName: lastName,
                password: password,
                bio: bio
            )
        }
        .done { [weak self] user in
            guard let self = self else { return }
            FFUser.shared.update(user: user)
            
            guard let mainTabBarController = UIViewController.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
        .catch { [weak self] error in
            guard let self = self else { return }
            AlertHelper.showAlert(message: error.localizedDescription, from: self)
        }
    }
    
    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private
    func showAlertMissingInfor(from fieldType: FieldType) {
        AlertHelper.showAlert(message: fieldType.desc, cancelCompletion: { [weak self] in
            guard let self = self else { return }
            switch fieldType {
            case .avatar:
                break
            case .email:
                self.emailTextField.resignFirstResponder()
            case .firstName:
                self.firstNameTextField.resignFirstResponder()
            case .lastName:
                self.lastNameTextField.resignFirstResponder()
            case .password:
                self.passwordTextField.resignFirstResponder()
            case .bio:
                self.bioTextField.resignFirstResponder()
            }
        })
    }
}

extension SignUpController {
    enum FieldType: String {
        case avatar,
             email,
             firstName,
             lastName,
             password,
             bio
        
        var desc: String {
            "Vui lòng cập nhật \(self.rawValue)"
        }
    }
}
