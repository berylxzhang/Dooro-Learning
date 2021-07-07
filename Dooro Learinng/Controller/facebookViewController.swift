//
//  facebookViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 7/3/21.
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
import SDWebImage

class facebookViewController: UIViewController {
    var userID: String?
    @IBOutlet weak var Photo: UIImageView!
    var facebookToken: String?
    var userName: String?
    var userPhoto: String?
    
    @IBAction func choosemode(_ sender: Any) {

        let credential = FacebookAuthProvider.credential(withAccessToken: self.facebookToken!)
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
                    print(self.userID!) }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController") as! ChooseModeViewController
                nextViewController.userID =   self.userID!
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:true, completion:nil)
                
                
            })
            
        
    }
    @IBOutlet weak var facebookLogin: UITextField!
    private let loginButton = FBLoginButton()
    
    @IBOutlet weak var nameWelcome: UILabel!
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        print(userPhoto)
        print(userName)
        print("facebookView")
//        let firstName = userName!
        if userPhoto != nil{
            self.Photo.sd_setImage(with: URL(string: userPhoto!), placeholderImage: UIImage(named: "loginDooro.png"))}
        // Do any additional setup after loading the view.
        
        guard let unwrappedName = userName else {
                print("Hello, anonymous!")
                return
            }
        
        nameWelcome.text = "👋🏻 Hi " + "\(unwrappedName)" +  "!😊"
        
        loginButton.frame = CGRect(x: facebookLogin.frame.origin.x, y:facebookLogin.frame.origin.y , width: facebookLogin.frame.width, height: facebookLogin.frame.height)

        
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
        FacebookLogin()
        guard let unwrappedfacebookToken = facebookToken else {
                print("no value")
                return
            }
        
        print(unwrappedfacebookToken )
//        print(self.userID!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func FacebookLogin()  {
        if let token = AccessToken.current,
                !token.isExpired {
            
        }
        
//        loginButton.frame = CGRect(x: 0, y:0 , width: 5, height: 10)
        
        
    }
    

    
}
extension facebookViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        if let token = AccessToken.current,
                !token.isExpired {
            
        }
 
}

}
