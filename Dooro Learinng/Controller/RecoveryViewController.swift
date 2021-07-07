//
//  RecoveryViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/25/21.
//

import UIKit
import MBProgressHUD
import Loaf
import Combine

class RecoveryViewController: UIViewController {
    var userID: String?
    private let authManager = AuthManager()
    private var subscriber: AnyCancellable?

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var recoveryEmailTextField: UITextField!
    
    @IBOutlet weak var hiddenbackground: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    @objc func goToLoginView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController")  as! ViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    
    }
    
    var gameTimer: Timer?
    
    @IBAction func confirmButton(_ sender: Any) {
        
            if let  email = recoveryEmailTextField.text, !email.isEmpty {
                
                authManager.resetPassword(withEmail: email) { [self] (result) in
                    switch result {
                    case .success:
                       
                        alertLabel.text = "Password Reset Successful"
                        
                        alertLabel.textAlignment = .center
                        alertLabel.textColor = hiddenbackground.textColor
                        showErrorMessageIfNeeded(text: "Please check your email to find the password reset link.")
                        
                        gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToLoginView), userInfo: nil, repeats: true)
                        
                    case .failure(let error):
                        Loaf(error.localizedDescription, state: .error, location: .top, sender: self).show()
                    }
                }
        }

    
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    private var errorMessage: String? {
        didSet {
            showErrorMessageIfNeeded(text: errorMessage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        observeTextFields()
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recoveryEmailTextField.becomeFirstResponder()
    }
    private func observeTextFields() {
        subscriber = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).sink { [unowned self] (notification) in
            guard let _ = (notification.object as? UITextField) else { return }
            showErrorMessageIfNeeded(text: nil)
        }
    }

    private func showErrorMessageIfNeeded(text: String?) {
        errorLabel.isHidden = text == nil
        errorLabel.text = text
        errorLabel.backgroundColor = hiddenbackground.backgroundColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
