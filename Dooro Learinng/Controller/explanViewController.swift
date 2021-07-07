//
//  explanViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/24/21.
//

import UIKit
import CoreData

class explanViewController: UIViewController {
    var userID: String?
    var index: Int?
    @IBOutlet weak var wordDisplay: UILabel!
    
    @IBOutlet weak var hintScrollView: UIScrollView!
    @IBOutlet weak var HintDisplay: UILabel!
    
    @IBOutlet weak var explanationScrollView: UIScrollView!
    @IBAction func DeleteWord(_ sender: Any) {
        if currentCard == nil{
            return
        } else{
            manageObjContext.delete(currentCard!)
            
            do {
                try manageObjContext.save()
                print("delete card")
                fetchCards()
            }catch{
                print("flash card could not be deleted")
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanGameController")  as! hangmanGameController
            nextViewController.userID = self.userID!
            nextViewController.modalPresentationStyle = .fullScreen
            
            self.present(nextViewController, animated:true, completion:nil)
            
        }
    }
    @IBOutlet weak var ExplanationDisplay: UILabel!
        
    var manageObjContext: NSManagedObjectContext!
    
    var listOfCards = [Wordcards]()
    var currentCard: Wordcards?
    var listOfWords = [String]()
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjContext = appDelegate.persistentContainer.viewContext
        fetchCards()
        
        wordDisplay.text = (currentCard!.word!)
        
        hintScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: HintDisplay.bottomAnchor).isActive = true
        explanationScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: ExplanationDisplay.bottomAnchor).isActive = true
        
        
        let HintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
        let HintString = "Hint:" + "\n"
        let Hint = NSMutableAttributedString(string: HintString, attributes: HintAttribute )
        
        
        
    let myHintString = "\(currentCard!.hint!)"
        let myHintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 26.0)!  ]
        
        let myHint =  NSMutableAttributedString(string: myHintString, attributes: myHintAttribute)
        
            Hint.append(myHint)
        HintDisplay.attributedText = Hint
        
        let paragraphStyle1 = NSMutableParagraphStyle()
             paragraphStyle1.alignment = .center
        

    
    let myWordAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 30.0)! ,NSAttributedString.Key.paragraphStyle: paragraphStyle1]
    let myWordString = "Explanation:" + "\n"
    let myWord = NSMutableAttributedString(string: myWordString, attributes: myWordAttribute )
    
    
       let paragraphStyle2 = NSMutableParagraphStyle()
            paragraphStyle2.alignment = .natural

    
    let myExplanString =   "\n" + "\(currentCard!.explanation!)"
        let myExplanAttribute =  [ NSAttributedString.Key.font: UIFont(name: "Arial Hebrew", size: 22.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle2  ]
    
        
    let myExplan =  NSMutableAttributedString(string: myExplanString, attributes: myExplanAttribute)
    
        
        
    myWord.append(myExplan)
    ExplanationDisplay.attributedText = myWord
        
        print("add hangman word")
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCards()

    }
    
    
    func fetchCards(){
        let fetchRequest : NSFetchRequest<Wordcards> = Wordcards.fetchRequest()
        
        do{
            fetchRequest.predicate = NSPredicate(format: "userID == %@", userID!)
            listOfCards = try manageObjContext.fetch(fetchRequest)
            
            print("fectched")

            if !listOfCards.isEmpty{
                for card in listOfCards{
                        if(card.userID == userID!){
                            if card.word != nil {
                                if !(card.word == ""){

                                    if  !listOfWords.contains(card.word!){
                                        listOfWords.append(card.word!)
                                    }
                                }else{
                                    self.index = listOfCards.index(of: card)
                                }
                        }
                        }else{}
                }
                listOfCards.remove(at: self.index!)
            }
        }catch{
            print("could not fetch")
        }
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
    
    @IBAction func tapAddWord(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanAddViewController")  as! hangmanAddViewController
        nextViewController.userID = self.userID!
        nextViewController.modalPresentationStyle = .fullScreen
       
        self.present(nextViewController, animated:true, completion:nil)
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
