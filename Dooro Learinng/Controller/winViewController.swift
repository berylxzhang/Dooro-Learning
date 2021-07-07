//
//  winViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/24/21.
//

import UIKit

class winViewController: UIViewController {

    var currentCard: Wordcards?
    var userID: String?
    
    @IBAction func redirect(_ sender: Any) {
        let displayVC : explanViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "explanViewController") as! explanViewController
        displayVC.currentCard = self.currentCard
        displayVC.userID = self.userID!
        displayVC.modalPresentationStyle = .fullScreen
        self.present(displayVC, animated:true, completion:nil)
    }
    
    
    @IBAction func tapNewWord(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanGameController")  as! hangmanGameController
        nextViewController.userID = self.userID!
        nextViewController.modalPresentationStyle = .fullScreen
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func tapExit(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController")  as! ChooseModeViewController
        nextViewController.userID = self.userID!
        nextViewController.modalPresentationStyle = .fullScreen
       
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        print("you win")
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
