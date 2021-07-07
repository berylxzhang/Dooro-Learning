//
//  FlaskCardViewController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/18/21.
//

import UIKit
import CoreData

class FlaskCardViewController: UIViewController {
    
    @IBOutlet weak var hint: UILabel!
    var userID: String?
    @IBOutlet weak var wordView: UITextField!
    var index: Int?
    var manageObjContext: NSManagedObjectContext!

    var listOfCards = [Wordcards]()

    var currentCard: Wordcards?
    var listOfWords = [String]()
    var fetchedCards = [Wordcards]()
    
    
    @IBAction func tapNewWord(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddWordViewController") as! AddWordViewController
        nextViewController.userID = self.userID!
        print( nextViewController.userID!)
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    

    @IBAction func tapExit(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController") as! ChooseModeViewController
        nextViewController.userID = self.userID!
        print( nextViewController.userID!)
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    enum  displayMode {
        case guessFirst
        case explanationFirst
    }
    
    var currentDisplayMode : displayMode = .guessFirst
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("flashcard")
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjContext = appDelegate.persistentContainer.viewContext
        
        
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
        
        print("start printing")
        fetchCards()
        printCards()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCards()
        printCards()
    }
    
    func fetchCards(){
        let fetchRequest : NSFetchRequest<Wordcards> = Wordcards.fetchRequest()
        
        do{
            fetchRequest.predicate = NSPredicate(format: "userID == %@", userID!)
            listOfCards = try manageObjContext.fetch(fetchRequest)
            
            print("fectched")
//            printCards()
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
    
    func printCards(){
        for card in listOfCards{
            print(card.word!)
            print(card.userID!)
            
        }
    }
    
    
    @IBAction func NewWord(_ sender: Any) {
    }
    
    @IBAction func ChooseMethod(_ sender: UISegmentedControl) {
        switch  sender.selectedSegmentIndex{
        case 0:
            currentDisplayMode = .guessFirst
        case 1:
            currentDisplayMode = .explanationFirst
        default:
            currentDisplayMode = .guessFirst
        }
    }
    
    func displayCard(){
        if listOfCards.count < 1 {
            let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
            let noCardString = "No cards with the input word"
            let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
            
            hint.attributedText = noCard
            currentCard = nil
            return
        }
        let randomIndex = Int(arc4random_uniform(UInt32(listOfCards.count)))
        currentCard = listOfCards[randomIndex]
        if let displayCard = currentCard{
            guard let word = wordView.text else{return }
            if word ==  ""{
                displayHintorExplanation(cardToDisplay: displayCard)
                
            }else if !listOfWords.contains(word){
                let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
                let noCardString = "No cards with the input word"
                let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
                hint.attributedText = noCard
                currentCard = nil
            }else if displayCard.word == word{
                displayHintorExplanation(cardToDisplay: displayCard)
            }else{
                self.displayCard()
            }

            
        }else{
            hint.text = "list is empty"
        }
    }
    
    func displayHintorExplanation(cardToDisplay card: Wordcards){
        switch currentDisplayMode{
        case .guessFirst:
            let HintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 36.0)!  ]
            let HintString = "Hint:" + "\n"
            let Hint = NSMutableAttributedString(string: HintString, attributes: HintAttribute )
            
            
            
            let myHintString = "\(card.hint!)"
            let myHintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 30.0)!  ]
            
            let myHint =  NSMutableAttributedString(string: myHintString, attributes: myHintAttribute)
            
                Hint.append(myHint)
            hint.attributedText = Hint
            hint.textAlignment = .natural
        case .explanationFirst:
            if card !=  nil {
                if card.word != nil  {
                    let myWordAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 36.0)!  ]
                    let myWordString = "\(card.word!)" + "\n"
                    let myWord = NSMutableAttributedString(string: myWordString, attributes: myWordAttribute )
                    
                    
                    
                    let myExplanString = "Explanation:" + "\n"
                    let myExplanAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 30.0)!  ]
                    
                    let myExplan =  NSMutableAttributedString(string: myExplanString, attributes: myExplanAttribute)
                    
                    myWord.append(myExplan)
                            
                            let myExplanationString = "\(card.explanation!)"
                            let myExplanationAttribute = [ NSAttributedString.Key.font: UIFont(name: "Arial Hebrew", size: 22.0)!  ]
                            
                            let myExplanation =  NSMutableAttributedString(string: myExplanationString, attributes: myExplanationAttribute)
                            
                            myWord.append(myExplanation)
                    
                    hint.attributedText = myWord
                    hint.textAlignment = .natural
                }else{let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 40.0)!  ]
                        let noCardString = "No cards with the input word"
                        let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
                        hint.attributedText = noCard}
                hint.textAlignment = .natural
                
            }else{let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 40.0)!  ]
                let noCardString = "No cards with the input word"
                let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
                hint.attributedText = noCard}
            hint.textAlignment = .natural
        }
        
    }
    
    
    @IBAction func DeleteWord(_ sender: Any) {
        if currentCard == nil{
            return
        } else{
            manageObjContext.delete(currentCard!)
            
            do {
                try manageObjContext.save()
                print("delete card")
                fetchCards()
                displayCard()
            }catch{
                print("flash card could not be deleted")
            }
        }
    }

    
    @IBAction func swipeRightAction(_ sender: Any) {
        displayCard()
        
    }
    
    @IBAction func swipeUpAction(_ sender: Any) {
        if currentCard == nil{
            let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
            let noCardString = "No cards with the input word"
            let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
            
            hint.attributedText = noCard
            hint.textAlignment = .natural
        return
        } else {
        if let card = currentCard{
            
            let HintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 40.0)!  ]
            let HintString = "Hint:" + "\n"
            let Hint = NSMutableAttributedString(string: HintString, attributes: HintAttribute )
            
            
            
            let myHintString = "\(card.hint!)"
            let myHintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 36.0)!  ]
            
            let myHint =  NSMutableAttributedString(string: myHintString, attributes: myHintAttribute)
            
                Hint.append(myHint)
            hint.attributedText = Hint
            hint.textAlignment = .natural
        }
            
        }
    }
    
    
    @IBAction func swipeDownAction(_ sender: Any) {
        if currentCard == nil{
            
            let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
            let noCardString = "No cards with the input word"
            let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
            
            hint.attributedText = noCard
            hint.textAlignment = .natural
        
            return
        
        } else {
        if let card = currentCard{
            
            let myWordAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 36.0)!  ]
            let myWordString = "\(card.word!)" + "\n"
            let myWord = NSMutableAttributedString(string: myWordString, attributes: myWordAttribute )
            
            
            
            let myExplanString = "Explanation:" + "\n"
            let myExplanAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 30.0)!  ]
            
            let myExplan =  NSMutableAttributedString(string: myExplanString, attributes: myExplanAttribute)
            
            myWord.append(myExplan)
                    
                    let myExplanationString = "\(card.explanation!)"
                    let myExplanationAttribute = [ NSAttributedString.Key.font: UIFont(name: "Arial Hebrew", size: 22.0)!  ]
                    
                    let myExplanation =  NSMutableAttributedString(string: myExplanationString, attributes: myExplanationAttribute)
                    
                    myWord.append(myExplanation)
            
            hint.attributedText = myWord
            hint.textAlignment = .natural
            
            
        }}
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
