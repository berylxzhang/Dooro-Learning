//
//  signUpViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/25/21.
//

import UIKit
import MBProgressHUD
import Loaf
import Combine

class signUpViewController: UIViewController {
    var userID: String?
    
    private let authManager = AuthManager()
    private var subscriber: AnyCancellable?
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private func observeTextFields() {
        subscriber = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).sink { [unowned self] (notification) in
            guard let _ = (notification.object as? UITextField) else { return }
            showErrorMessageIfNeeded(text: nil)
        }
    }
    private func showErrorMessageIfNeeded(text: String?) {
        errorLabel.isHidden = text == nil
        errorLabel.text = text
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let passwordConfirmation = passwordConfirmationTextField.text,
            !passwordConfirmation.isEmpty else {
            showErrorMessageIfNeeded(text: "Invalid form")
            return }
        
        guard password == passwordConfirmation else {
            showErrorMessageIfNeeded(text: "Passwords are incorrect")
            return }

        MBProgressHUD.showAdded(to: view, animated: true)
        
        authManager.signUpNewUser(withEmail: email, password: password) { [weak self] (result) in
            guard let this = self else { return }
            MBProgressHUD.hide(for: this.view, animated: true)
            switch result {
            case .success:
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self!.present(nextViewController, animated:true, completion:nil)
                
            case .failure(let error):
                this.showErrorMessageIfNeeded(text: error.localizedDescription)
            }
        }
    }
    
    private var errorMessage: String? {
        didSet {
            showErrorMessageIfNeeded(text: errorMessage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    var iconClick = false
    let imageicon = UIImageView()
    
    var iconClick1 = false
    let imageicon1 = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        observeTextFields()
        // Do any additional setup after loading the view.
        imageicon.image = UIImage(systemName: "eye.slash")
        imageicon1.image = UIImage(systemName: "eye.slash")
        
        let contentView = UIView()
        contentView.addSubview(imageicon)
        let contentView1 = UIView()
        contentView1.addSubview(imageicon1)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName:  "eye.slash")!.size.width, height: UIImage(systemName:  "eye.slash")!.size.height)
        
        contentView1.frame = CGRect(x: 0, y: 0, width: UIImage(systemName:  "eye.slash")!.size.width, height: UIImage(systemName:  "eye.slash")!.size.height)
        
        imageicon.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "eye.slash")!.size.width, height: UIImage(systemName:  "eye.slash")!.size.height)
        
        imageicon1.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "eye.slash")!.size.width, height: UIImage(systemName:  "eye.slash")!.size.height)
        
        passwordTextField.rightView = contentView
        passwordConfirmationTextField.rightView = contentView1
        passwordTextField.rightViewMode = .always
        passwordConfirmationTextField.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped( tapGestureRecognizer: )))
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGestureRecognizer)
        
        imageicon1.isUserInteractionEnabled = true
        imageicon1.addGestureRecognizer(tapGestureRecognizer1)
        
        
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
  
        if iconClick{
            iconClick = false
            tappedImage.image = UIImage(systemName:  "eye.slash")
            passwordTextField.isSecureTextEntry = true
        }
        else{
            iconClick = true
            tappedImage.image = UIImage(systemName:  "eye")
            passwordTextField.isSecureTextEntry = false
        }
        
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        if iconClick1{
            iconClick1 = false
            tappedImage.image = UIImage(systemName:  "eye.slash")
            passwordConfirmationTextField.isSecureTextEntry = true
        }
        else{
            iconClick1 = true
            tappedImage.image = UIImage(systemName:  "eye")
            passwordConfirmationTextField.isSecureTextEntry = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
