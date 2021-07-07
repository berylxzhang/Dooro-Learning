//
//  hangmanAddViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/25/21.
//

import UIKit
import CoreData
import Foundation
import  KMPlaceholderTextView

class hangmanAddViewController: UIViewController, UITextFieldDelegate {
    var manageObjContext: NSManagedObjectContext!
    
    var userID: String?
    @IBOutlet weak var wordText: UITextField!
    
    @IBOutlet weak var HintText: KMPlaceholderTextView!
    
    @IBOutlet weak var ExplanationText: KMPlaceholderTextView!
    
    func textField(_ textField : UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "abcdefghijklmnopqrstuvwxyz"
        let allowedCharcterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharcterSet.isSuperset(of: typedCharacterSet)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        manageObjContext = appDelegate.persistentContainer.viewContext
        
        wordText.autocapitalizationType = .none;
        
        wordText.delegate = self
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
    }
    

    @IBAction func SaveWord(_ sender: Any) {
        guard let word = wordText.text else { return }
        guard let hint = HintText.text else { return }
        guard let explanation = ExplanationText.text else{ return }

        if word != "" &&  hint != "" && explanation != ""{
            saveCardToDataBase(word:word, hint: hint, explanation:explanation, userID: self.userID!)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanGameController") as! hangmanGameController
            nextViewController.userID = self.userID!
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            
        }
    }
    
    
    
    @IBAction func tapCancel(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanGameController") as! hangmanGameController
        nextViewController.userID = self.userID!
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    func saveCardToDataBase(word:String, hint: String, explanation: String, userID: String){
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Wordcards", into: manageObjContext) as! Wordcards
        newCard.word = word
        newCard.hint = hint
        newCard.explanation = explanation
        newCard.userID = userID
        
        do {
            try manageObjContext.save()
            print("save sucessfylly")
        } catch{print("Could not save")}
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
