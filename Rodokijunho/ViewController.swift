//
//  ViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startQuizButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.startButton.setTitle("", for: UIControl.State.normal)
        self.startQuizButtonOutlet.setTitle("", for: .normal)
    }

    @IBAction func startChecking(_ sender: Any) {
    }
    
    @IBAction func startQuizButton(_ sender: Any) {
        print("クイズを始めます")
        performSegue(withIdentifier: "toQuizViewSegue", sender: nil)
    }
    
}

