//
//  ViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/26.
//

import UIKit
import Firebase
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startQuizButtonOutlet: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startButton.setTitle("", for: UIControl.State.normal)
        self.startQuizButtonOutlet.setTitle("", for: .normal)
        
        // RxSwiftTest
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        subject
            .subscribe { event in
                print("event: \(event)")
            } onError: { err in
                print("error: \(err)")
            } onCompleted: {
                print("onCompleted!")
            } onDisposed: {
                print("onDisposed!")
            }
        subject.onNext("first onNext")
        subject.onNext("second onNext")
        subject.onCompleted()
    }

    @IBAction func startChecking(_ sender: Any) {
    }
    
    @IBAction func startQuizButton(_ sender: Any) {
        print("クイズを始めます")
        performSegue(withIdentifier: "toQuizViewSegue", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear")
    }
}

