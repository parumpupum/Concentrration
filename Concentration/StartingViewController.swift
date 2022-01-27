//
//  StartingViewController.swift
//  Concentration
//
//  Created by Kirill Hobyan on 25.12.21.
//

import UIKit

class StartingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func startButtonTouch(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "main")
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
        
    }
    
}
