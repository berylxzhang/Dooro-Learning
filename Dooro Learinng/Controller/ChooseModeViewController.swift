//
//  ChooseModeViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/18/21.
//

import UIKit
import CoreData
import Foundation
import Firebase
import FirebaseAuth

class ChooseModeViewController: UIViewController {
    var manageObjContext: NSManagedObjectContext!
    var userID: String?
    let defaults = UserDefaults.standard
    
    var listOfCards = [Wordcards]()
    var userListOfCards = [Wordcards]()

    
    @IBAction func tapHangman(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanGameController") as! hangmanGameController
                        nextViewController.userID =   self.userID!
                        print( nextViewController.userID!)
                        nextViewController.modalPresentationStyle = .fullScreen
                        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("choose mode")
        
        guard let unwrappeduserID = self.userID else {
                return
            }

            print(unwrappeduserID)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Wordcards> = Wordcards.fetchRequest()
        
        var flagUserID = false

        do{
            listOfCards = try manageObjContext.fetch(fetchRequest)
            print("fectched")
            if !listOfCards.isEmpty{
                for card in listOfCards{
                    if card !=  nil{
                        if (card.userID == userID!) {
                                flagUserID = true
                                break
                        }
                }
                }
            }
        }catch{
            print("could not fetch")
        }
//
        
        
        
        
        if flagUserID == true{
            print("Second+")
//            defaults.set(true, forKey: "First Launch")
        }else{
            print("First")
            
            saveCardToDataBase(word:"", hint: "", explanation:"", userID: self.userID!)
            
            var wordArray : [String] = ["candle",
                                        "sponge",
                                        "future",
                                        "promise",
                                        "age",
                                        "towel",
                                        "barber",
                                        "bank",
                                        "echo",
                                        "darkness",
                                        "piano",
                                        "dictionary",
                                        "secret",
                                        "staircase",
                                        "name"
            ]
            var hintArray : [String] = ["I’m tall when I’m young, and I’m short when I’m old. What am I?",
                                        "What is full of holes but still holds water?",
                                        "What is always in front of you but can’t be seen?",
                                        "What can you break, even if you never pick it up or touch it?",
                                        "What goes up but never comes down?",
                                        "What gets wet while drying?",
                                        "I shave every day, but my beard stays the same. What am I?",
                                        "I have branches, but no fruit, trunk or leaves. What am I?",
                                        "What can’t talk but will reply when spoken to?",
                                        "The more of this there is, the less you see. What is it?",
                                        "What has many keys but can’t open a single lock?",
                                        "Where does today come before yesterday?",
                                        "If you’ve got me, you want to share me; if you share me, you haven’t kept me. What am I?",
                                        "What goes up and down but doesn’t move?",
                                        "It belongs to you, but other people use it more than you do. What is it?"
                                        
            ]
            var explanationArray: [String] = ["an ignitable wick embedded in wax, or another flammable solid substance such as tallow, that provides light, and in some cases, a fragrance",
                                              "a porous rubber or cellulose product used similarly to a sponge",
                                              "1.existing or occurring at a later time \n2.an expectation of advancement or progressive development",
                                              "a declaration that one will do or refrain from doing something specified",
                                              "an individual's development measured in terms of the years requisite for like development of an average individual",
                                              "an absorbent cloth or paper for wiping or drying",
                                              "one whose business is cutting and dressing hair, shaving and trimming beards, and performing related services",
                                              "an establishment for the custody, loan, exchange, or issue of money, for the extension of credit, and for facilitating the transmission of funds",
                                              "1.the sound due to such reflection \n2.a soft repetition of a musical phrase",
                                              "1.the total or near total absence of light \n2.the quality of being dark in shade or color \n3.a gloomy or depressed state or tone",
                                              "a musical instrument having steel wire strings that sound when struck by felt-covered hammers operated from a keyboard",
                                              "a reference book listing alphabetically the words of one language and showing their meanings or translations in another language",
                                              "1.kept from knowledge or view \n2.something kept hidden or unexplained \n3.remote from human frequentation or notice",
                                              "the structure containing a stairway \n a flight of stairs with the supporting framework, casing, and balusters",
                                              "1.a word or phrase that constitutes the distinctive designation of a person or thing \n2.a word or symbol used in logic to designate an entity"
            ]
            
            for i in 0..<wordArray.count{
                saveCardToDataBase(word:wordArray[i], hint: hintArray[i], explanation:explanationArray[i],userID:self.userID!)
            }
        }

       
        
    }
    
    @IBAction func tapFlashCard(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FlashCardView") as! FlaskCardViewController
                        nextViewController.userID =   self.userID!
                        print( nextViewController.userID!)
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
