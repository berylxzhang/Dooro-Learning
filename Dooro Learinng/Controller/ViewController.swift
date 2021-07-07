///Users/berylxzhang/Documents/Dooro Learinng/Dooro Learinng/ViewController.swift
//  ViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/18/21.
//

import UIKit
import MBProgressHUD
import Loaf
import Combine
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import GoogleSignIn
import SDWebImage

// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift


// Add this to the body

class ViewController: UIViewController{
    var googleSignIn = GIDSignIn.sharedInstance()

    
    var userID: String?
    @IBOutlet weak var Photo: UIImageView!
    private let authManager = AuthManager()
    private var subscriber: AnyCancellable?
    
    
    @IBOutlet weak var facebookButton: UIButton!

    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBOutlet weak var googleButton: UIButton!
    
    //    @IBOutlet weak var facebookButton: UIButton!
    //    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgetpasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    private let loginButton = FBLoginButton(frame: .zero, permissions: [.publicProfile])
    
    private var errorMessage: String? {
        didSet {
            showErrorMessageIfNeeded(text: errorMessage)
        }
    }
    
    
    var iconClick = false
    let imageicon = UIImageView()
    
    let facebookimageicon = UIImageView()
    let googleimageicon = UIImageView()
    //
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        imageicon.image = UIImage(systemName: "eye.slash")
        
        let contentView = UIView()
        contentView.addSubview(imageicon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName:  "eye.slash")!.size.width, height: UIImage(systemName:  "eye.slash")!.size.height)
        
        imageicon.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "eye.slash")!.size.width, height: UIImage(systemName:  "eye.slash")!.size.height)
        
        passwordTextField.rightView = contentView
        passwordTextField.rightViewMode = .always
        
        facebookimageicon.image = UIImage(named: "facebook_logo.png")
        let size = facebookimageicon.image?.size
       
        let buttonheight = facebookButton.frame.height
        let buttonwidth = facebookButton.frame.width
        let imageWidth = facebookButton.imageView!.frame.width
        facebookButton.imageEdgeInsets = UIEdgeInsets(top:4, left:4,bottom: 4, right: 4+buttonwidth-buttonheight)
        facebookButton.setImage(facebookimageicon.image, for: .normal)
        
        
        googleimageicon.image = UIImage(named: "google_logo.png")
        googleButton.imageEdgeInsets = UIEdgeInsets(top:4, left:4,bottom: 4, right: 4+buttonwidth-buttonheight)
        googleButton.setImage(googleimageicon.image, for: .normal)
        
        
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGestureRecognizer)
        
        
//        loginButton.frame = CGRect(x: facebookLogin.frame.origin.x, y:facebookLogin.frame.origin.y + (passwordTextField.frame.origin.y - emailTextField.frame.origin.y - passwordTextField.frame.height) , width: facebookLogin.frame.width, height: facebookLogin.frame.height)
        
        
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        loginButton.isHidden = true
        
        view.addSubview(loginButton)
        
//        googleLoginButton.setImage(UIImage(named: "google_logo.png"), for: UIControl.State.Normal)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

        
        FacebookLogin()
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
//        print("logged in")
        }
        else
        {
        //not loggedIn
//            print("nobody")
        }
        
        
        print(self.userID)
        }
    // Swift

    @IBAction func tapGoogleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()


        
        
    }
    @IBAction func tapFacebookLogin(_ sender: Any) {
        
        loginButton.sendActions(for: .touchUpInside)
        
        

    }
    
    
    
    @IBAction func taplogin(_ sender: Any) {
        view.endEditing(true)
        
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
            showErrorMessageIfNeeded(text: "Invalid form")
            return }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        authManager.loginUser(withEmail: email, password: password) { [weak self] (result) in
            guard let this = self else { return }
            MBProgressHUD.hide(for: this.view, animated: true)
            switch result {
            case .success:
                if let loginUser = Auth.auth().currentUser{
                    print("Current firebase user is")
                    print(loginUser)
                    self!.userID = loginUser.uid
                    print(loginUser.uid)
                    print(self!.userID!)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController") as! ChooseModeViewController
                nextViewController.modalPresentationStyle = .fullScreen
                nextViewController.userID = self?.userID
                print( nextViewController.userID!)
                    self!.present(nextViewController, animated:true, completion:nil)}
                
                
            case .failure(let error):
                this.showErrorMessageIfNeeded(text: error.localizedDescription)
            }
        }
    }
    var userName: String?
    var userPhoto: String?
    
    var facebookToken: String?
    var googleuserName: String?
    var googleuserPhoto: String?
    
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

    @IBOutlet weak var login: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
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
    }
    
    func FacebookLogin()  {
        if let token = AccessToken.current,
                !token.isExpired {
            let token = token.tokenString
            
            let request = FBSDKShareKit.GraphRequest(graphPath: "me",
                                                     parameters: ["fields":"email,name,picture,first_name"],
                                                     tokenString: token,
                                                     version: nil,
                                                     httpMethod: .get)
            request.start(completionHandler: { connection, result,error in
                print("\(result)")
                
                let dict = result as! [String: AnyObject]
                let profileDic = dict as NSDictionary
                let first_name = profileDic.object(forKey: "first_name") as! String
                let temURL1 = profileDic.object(forKey: "picture") as! NSDictionary
                let temTRL2 = temURL1.object(forKey: "data") as! NSDictionary
                let profileURL = temTRL2.object(forKey: "url") as! String
                print(first_name)
                print(profileURL)
                self.userName = first_name
                self.userPhoto = profileURL
                self.facebookToken = token
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                print(token)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "facebookView") as! facebookViewController
                nextViewController.userName = self.userName
                nextViewController.userPhoto = self.userPhoto
                nextViewController.facebookToken = self.facebookToken
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:false, completion:nil)
                
           
        })
            firebaseFacebooklogin(accessToken: token)
            
            
        }
        
//        loginButton.frame = CGRect(x: 0, y:0 , width: 5, height: 10)
        
        
    }
    
    
    func firebaseFacebooklogin(accessToken: String){
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken )
        Auth.auth().signIn(with: credential, completion: { ( authResult, error)  in
            
            if let error = error{
                print("Firebase login Error")
                print(error)
                return
            }
            //User has signed
            print("Firebase Login Done")
            print(authResult)
            
            if let user = Auth.auth().currentUser{
                print("Current firebase user is")
                print(user)
                self.userID = user.uid
                print(user.uid)
                print(self.userID!)
                
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//                let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "signUpViewController") as! signUpViewController
//                signUpViewController.userID =   self.userID!
//
//                print(signUpViewController.userID! )
//
//                let RecoveryViewController = storyBoard.instantiateViewController(withIdentifier: "RecoveryViewController") as! RecoveryViewController
//                RecoveryViewController.userID =   self.userID!
//
//                let facebookViewController = storyBoard.instantiateViewController(withIdentifier: "facebookView") as! facebookViewController
//                facebookViewController.userID =   self.userID!
//
//                let googleViewController = storyBoard.instantiateViewController(withIdentifier: "googleViewController") as! googleViewController
//                googleViewController.userID =   self.userID!
//
//                let ChooseModeViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController") as! ChooseModeViewController
//                ChooseModeViewController.userID =   self.userID!
//
//                print(ChooseModeViewController.userID! )
//
//                let hangmanGameController = storyBoard.instantiateViewController(withIdentifier: "hangmanGameController") as! hangmanGameController
//                hangmanGameController.userID =   self.userID!
//
//
//                let FlaskCardViewController = storyBoard.instantiateViewController(withIdentifier: "FlashCardView") as! FlaskCardViewController
//                FlaskCardViewController.userID =   self.userID!
//
//                let winViewController = storyBoard.instantiateViewController(withIdentifier: "winViewController") as! winViewController
//                winViewController.userID =   self.userID!
//
//                let looseViewController = storyBoard.instantiateViewController(withIdentifier: "looseViewController") as! looseViewController
//                looseViewController.userID =   self.userID!
//
//                let AddWordViewController = storyBoard.instantiateViewController(withIdentifier: "AddWordViewController") as! AddWordViewController
//                AddWordViewController.userID =   self.userID!
//
//                let explanViewController = storyBoard.instantiateViewController(withIdentifier: "explanViewController") as! explanViewController
//                explanViewController.userID =   self.userID!
//
//                let hangmanAddViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanAddViewController") as! hangmanAddViewController
//                hangmanAddViewController.userID =   self.userID!
                
                
            }
    })
        }
}

extension ViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {

        print("Logout")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        FacebookLogin()

}

}


//
extension ViewController: GIDSignInDelegate {func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
    if let error = error{
        print("\(error.localizedDescription)")
    }else{

        let userIdToken = user.authentication.idToken ?? ""
        print("Google ID Token: \(userIdToken)")

        let userFirstName = user.profile.givenName ?? ""
        print("Google User First Name: \(userFirstName)")

        let userLastName = user.profile.familyName ?? ""
        print("Google User Last Name: \(userLastName)")

        let userEmail = user.profile.email ?? ""
        print("Google User Email: \(userEmail)")

        let googleProfilePicURL = user.profile.imageURL(withDimension: 150)?.absoluteString ?? ""
        print("Google Profile Avatar URL: \(googleProfilePicURL)")
        
        
        self.googleuserName = userFirstName
        self.googleuserPhoto = googleProfilePicURL
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                         accessToken: authentication.accessToken)

        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error{
                print("Firebase sign in error")
                print(error)
                return
            } else{
                print("User is signed in with firebase")
                
                
            }
            if let googleUser = Auth.auth().currentUser{
                print("Current firebase user is")
                print(googleUser)
                self.userID = googleUser.uid
                print(googleUser.uid)
                print(self.userID!)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "googleViewController") as! googleViewController
            nextViewController.userName =   self.googleuserName
            nextViewController.userPhoto = self.googleuserPhoto
            nextViewController.userID = self.userID
            print( nextViewController.userID!)
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            

        }
    }



}
}
}
