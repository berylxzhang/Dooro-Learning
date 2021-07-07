//
//  googleViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 7/4/21.
//

import UIKit
import MBProgressHUD
import Loaf
import Combine
import Firebase
import FirebaseAuth
import GoogleSignIn
import SDWebImage
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class googleViewController: UIViewController {
    
    @IBOutlet weak var Photo: UIImageView!
    var userID: String?
    var userName: String?
    var userPhoto: String?
    let googleimageicon = UIImageView()
    
    @IBOutlet weak var googleLogOut: UIButton!
    @IBOutlet weak var nameWelcome: UILabel!
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        if userPhoto != nil{
            self.Photo.sd_setImage(with: URL(string: userPhoto!), placeholderImage: UIImage(named: "loginDooro.png"))}
        // Do any additional setup after loading the view.
        
        guard let unwrappedName = userName else {
                print("Hello, anonymous!")
                return
            }
        
        nameWelcome.text = "👋🏻 Hi " + "\(unwrappedName)" +  "!😊"
        
        
        let buttonheight = googleLogOut.frame.height
        let buttonwidth = googleLogOut.frame.width
        
        googleimageicon.image = UIImage(named: "google_logo.png")
        googleLogOut.imageEdgeInsets = UIEdgeInsets(top:4, left:4,bottom: 4, right: 4+buttonwidth-buttonheight)
        googleLogOut.setImage(googleimageicon.image, for: .normal)
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
        print("logged in")
        }
        else
        {
        //not loggedIn
            print("nobody")
        }
        
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapChooseMode(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController") as! ChooseModeViewController
        nextViewController.userID =   self.userID!
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func googleLogOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
        //loggedIn
        }
        else
        {
        //not loggedIn
            print("Successfully logged out")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as!ViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
}
