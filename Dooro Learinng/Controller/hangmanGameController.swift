//
//  hangmanGameController.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/24/21.
//

import UIKit
import CoreData

class hangmanGameController: UIViewController , UITextFieldDelegate{

    var userID: String?
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var hintLabel: UILabel!
    //    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var wordToGuessDisplay: UILabel!
    @IBOutlet weak var remainingChances: UILabel!
    @IBOutlet weak var letterBank: UILabel!
    @IBOutlet weak var guessInput: UITextField!
    @IBOutlet weak var letterBankScrollView: UIScrollView!
    
    var manageObjContext: NSManagedObjectContext!
    
    var listOfCards = [Wordcards]()
    var currentCard: Wordcards?
    var listOfWords = [String]()
    var listOfHints = [String]()
    var fetchedCards = [Wordcards]()
    
    var index: Int?
    
    var wordToGuess: String!
    var wordAsUnderscores : String = ""
    let maxNumOfGuesses:Int = 5
    var remainingGuesses: Int!
    var randomNumber : Int = 0
    
    var gameTimer: Timer?
    
    @objc func goToWinView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "winViewController")  as! winViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.currentCard = self.currentCard
        nextViewController.userID = self.userID!
        self.present(nextViewController, animated:true, completion:nil)
        
    
    }
    
    @objc func goToLooseView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "looseViewController")  as! looseViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.currentCard = self.currentCard
        nextViewController.userID = self.userID!
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjContext = appDelegate.persistentContainer.viewContext
        fetchCards()
        // Do any additional setup after loading the view.
        guessInput.delegate = self
        guessInput.isEnabled = false
        fetchCards()
        
        print("hangman")
        
        guard let unwrappedID = userID else {
                print("no value")
                return
            }
        
        print(unwrappedID )
        
        let hintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Arial Rounded MT Bold", size: 36.0)!  ]
        let hintString = "\n" + "\n" + "Hint"
        let hintFinal = NSMutableAttributedString(string: hintString, attributes: hintAttribute )
        
    
        hintLabel.attributedText = hintFinal

        
        
        scrollview.contentLayoutGuide.bottomAnchor.constraint(equalTo: hintLabel.bottomAnchor).isActive = true
        letterBankScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: letterBank.bottomAnchor).isActive = true
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
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var vc = segue.destination as! explanViewController
//        vc.currentCard = self.currentCard
//    }
    
    @objc func goToNewCardView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "hangmanAddViewController")  as! hangmanAddViewController
        
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.userID = self.userID!
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func newGame(_ sender: Any) {
        if listOfCards.count < 1{
            let noCardAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
            let noCardString = "No cards to play with" + "\n" + "Redirecting now -_-!"
            let noCard = NSMutableAttributedString(string: noCardString, attributes: noCardAttribute )
            
            hintLabel.attributedText = noCard
            currentCard = nil
            
            gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(goToNewCardView), userInfo: nil, repeats: true)
            
            return
        }
        

        reset()
        
        if listOfCards.count == 1 {
            wordToGuess = listOfCards[0].word
            let hint = listOfCards[0].hint
            
            let hintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
            let hintString = "Hint: \(wordToGuess.count) letters" + "\n"
            let hintFinal = NSMutableAttributedString(string: hintString, attributes: hintAttribute )
            
            
            let hintTextAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 28.0)!]
            let hintTextString = "\(hint!)"
            let hintTextFinal = NSMutableAttributedString(string: hintTextString, attributes: hintTextAttribute )
            
            hintFinal.append(hintTextFinal)
            hintLabel.attributedText = hintFinal
            hintLabel.sizeToFit()
            currentCard = listOfCards[0]
            
            for _ in 1...wordToGuess.count {
                wordAsUnderscores.append("_")
            }
            wordToGuessDisplay.text = wordAsUnderscores
        }
      
        if listOfCards.count > 1 {
        let index = chooseRandomNumber()
        wordToGuess = listOfCards[index].word
        let hint = listOfCards[index].hint
        
            let hintAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 32.0)!  ]
            let hintString = "Hint: \(wordToGuess.count) letters" + "\n"
            let hintFinal = NSMutableAttributedString(string: hintString, attributes: hintAttribute )
            
            
            let hintTextAttribute = [ NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 28.0)!]
            let hintTextString = "\(hint!)" + "\n"
            let hintTextFinal = NSMutableAttributedString(string: hintTextString, attributes: hintTextAttribute )
            
            hintFinal.append(hintTextFinal)
            hintLabel.attributedText = hintFinal

            hintLabel.sizeToFit()
        
        currentCard = listOfCards[index]
        
        for _ in 1...wordToGuess.count {
            wordAsUnderscores.append("_")
        }
        wordToGuessDisplay.text = wordAsUnderscores
        }
    }
    
    func reset() {
        remainingGuesses = maxNumOfGuesses
        remainingChances.text = "\(remainingGuesses!) guesses left."
        wordAsUnderscores = ""
        guessInput.text?.removeAll()
        letterBank.text?.removeAll()
        guessInput.isEnabled = true
        
    }
    
    func chooseRandomNumber() -> Int {
        var newRandomInt : Int = Int(arc4random_uniform(UInt32(listOfCards.count)))
        if (newRandomInt == randomNumber) {
            newRandomInt = chooseRandomNumber()
        } else {
            randomNumber = newRandomInt
        }
        return newRandomInt
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let letterGuessed = textField.text else { return }
        if letterGuessed.isEmpty == true {return }
        guessInput.text?.removeAll()
        var currentLetterBank : String = letterBank.text ?? ""
        if currentLetterBank.contains(letterGuessed) {
            return
        } else {
            if wordToGuess.contains(letterGuessed) {
               CorrectGuessVerify(letterGuessed: letterGuessed)
            } else {
                IncorrectGuessVerify()
            }
            letterBank.text?.append("\(letterGuessed), ")
        }
    }
    
    func CorrectGuessVerify(letterGuessed : String) {
        let characterGuessed = Character(letterGuessed)
        for index in wordToGuess.indices {
            if wordToGuess[index] == characterGuessed {
                let endIndex = wordToGuess.index(after: index)
                let charRange = index..<endIndex
                wordAsUnderscores = wordAsUnderscores.replacingCharacters(in: charRange, with: letterGuessed)
                wordToGuessDisplay.text = wordAsUnderscores
            }
        }
        if !(wordAsUnderscores.contains("_")) {
            remainingChances.text = "You win! :)"
            guessInput.isEnabled = false
            gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(goToWinView), userInfo: nil, repeats: true)
            

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
    }
    
    func IncorrectGuessVerify() {
        remainingGuesses! -= 1
        if remainingGuesses == 0 {
            remainingChances.text = "You lose! :("
            remainingChances.isEnabled = false
            gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(goToLooseView), userInfo: nil, repeats: true)
        } else {
            remainingChances.text = "\(remainingGuesses!) guesses left"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guessInput.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet.lowercaseLetters
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if let _ = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive) {
                return true
            }
        }
        return false
    }
    
    @IBAction func tapExit(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseModeViewController")  as! ChooseModeViewController
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
