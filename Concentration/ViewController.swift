//
//  ViewController.swift
//  Concentration
//
//  Created by Kirill Hobyan on 20.09.21.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var highscore: Int{
        set{
            UserDefaults.standard.set(newValue, forKey: "highscore")
            UserDefaults.standard.synchronize()
        }
        get{
            if let value = UserDefaults.standard.value(forKey: "highscore") as? Int{
                return value
            } else{
                return 1000000
            }
        }
    }
    
    var numberOfPairsOfCards: Int{
        return (buttonsCollection.count + 1) / 2
    }
    
    private  func updateTouches(){
        touchLabel.text = "Touches: \(touches)"
    }
    
    private(set) var touches = 0{
        didSet{
            updateTouches()
        }
    }
    
    @IBOutlet private var buttonsCollection: [UIButton]!
    @IBOutlet weak var highscoreLabel: UILabel!{
        didSet{
            if (highscore < 1000000){ highscoreLabel.text = "Highscore: \(highscore)" }
        }
    }
    @IBOutlet private weak var touchLabel: UILabel! {
        didSet{
            updateTouches()
        }
    }
    //private var emojiCollection = ["🦊", "🐷", "🐶", "🐱", "🐭", "🐹", "🐰", "🐻", "🐼", "🐻‍❄️", "🐨",
    //"🐯", "🦁", "🐮", "🐸", "🐵", "🐔", "🐧", "🐤", "🐠", "🐊", "🌹", "🔥"]
    private var emojiCollection = "🦊🐷🐶🐱🐭🐹🐰🐻🐼🐻‍❄️🐨🐯🦁🐮🐸🐵🐔🐧🐤🐠🐊🌹🔥"
    private var emojiDictrionari = [Card:String]()
  
    private func emojiIdentifier(for card: Card) -> String{
        if emojiDictrionari[card] == nil{
            let randomStringIndex = emojiCollection.index(emojiCollection.startIndex, offsetBy: emojiCollection.count.arc4randomExtension)
            emojiDictrionari[card] = String(emojiCollection.remove(at: randomStringIndex)) 
        }
        return emojiDictrionari[card] ?? "?"
    }
    
    private func updateViewFromModel(){
        var countOfCards = 0
        for index in buttonsCollection.indices{
            let button = buttonsCollection[index]
            let card = game.cards[index]
            
            if card.isMatched == false { countOfCards += 1 }
            if card.isFaceUp{
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
        }
        
        if countOfCards == 0{
            
            let alert = UIAlertController(title: "You win!", message: "Your score is \(touches)!", preferredStyle: .alert)
            
            let backButton = UIAlertAction(title: "Back", style: .default) { x in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let startVC = storyBoard.instantiateViewController(withIdentifier: "startVC")
                startVC.modalPresentationStyle = .fullScreen
                self.present(startVC, animated: false, completion: nil)
            }
            let restartButton = UIAlertAction(title: "Restart", style: .default) { x in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "main")
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: false, completion: nil)
            }
            alert.addAction(backButton)
            alert.addAction(restartButton)
            
            if touches < highscore{ highscore = touches }
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction private func buttonTouch(_ sender: UIButton) {
        if let buttonIndex = buttonsCollection.firstIndex(of: sender){
            if !game.cards[buttonIndex].isMatched && !game.cards[buttonIndex].isFaceUp{ touches += 1 }
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
    }
    
}

extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

