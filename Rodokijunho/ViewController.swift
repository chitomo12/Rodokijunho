//
//  ViewController.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/26.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var startCheckingButton: UIButton!
    @IBOutlet weak var startQuizButton: UIButton!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var startCheckNSObj: StartCheckingNSObject!
    var startQuizNSObj: StartQuizNSObject!
    
    var maskUIViewOne = UIView()
    var maskUIViewTwo = UIView()
    var baseRadius = UIScreen.main.bounds.width / 2
    
    var isShowCheckingModeGuide = false
    var isShowQuizModeGuide = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startCheckingButton.setTitle("", for: UIControl.State.normal)
        self.startQuizButton.setTitle("", for: .normal)
        
        // 以下テスト部分
        startCheckNSObj = StartCheckingNSObject()
        startCheckNSObj.startCheckingView.isUserInteractionEnabled = false
        startCheckNSObj.startCheckingView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(startCheckNSObj.startCheckingView)
        
        startQuizNSObj = StartQuizNSObject()
        startQuizNSObj.startQuizView.isUserInteractionEnabled = false
        startQuizNSObj.startQuizView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(startQuizNSObj.startQuizView)
        
//        var sampleWidth = 30
//
//        let maskPath = CGMutablePath()
//        maskPath.addEllipse(in: CGRect(x: 10, y: 10, width: 30, height: 30))
//        maskPath.addEllipse(in: CGRect(x: 60, y: 10, width: sampleWidth, height: 30))
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        maskLayer.fillColor = UIColor.black.cgColor
        
        maskUIViewOne.backgroundColor = UIColor.black
//        maskUIViewOne.frame = CGRect(x: startCheckingButton.frame.midX, y: startCheckingButton.frame.midY, width: 0, height: 0)
        maskUIViewOne.layer.cornerRadius = maskUIViewOne.frame.width / 2
        startCheckNSObj.startCheckingView.mask = maskUIViewOne
        
        maskUIViewTwo.backgroundColor = UIColor.black
//        maskUIViewTwo.frame = CGRect(x: startQuizButton.frame.midX, y: startQuizButton.frame.midY, width: 0, height: 0)
        maskUIViewTwo.layer.cornerRadius = maskUIViewTwo.frame.width / 2
        startQuizNSObj.startQuizView.mask = maskUIViewTwo
        
        // StartCheckNSObjとStartQuizNSObjの各要素にイベントを追加
        startCheckNSObj.button.addTarget(self, action: #selector(toggleMaskViewOne), for: .touchUpInside)
        startCheckNSObj.startCheckingButton.addTarget(self, action: #selector(segueToCheckingMode), for: .touchUpInside)
        startQuizNSObj.button.addTarget(self, action: #selector(toggleMaskViewTwo), for: .touchUpInside)
        startQuizNSObj.startQuizButton.addTarget(self, action: #selector(segueToQuizMode), for: .touchUpInside)
    }
    
    @objc func toggleMaskViewOne() {
        if isShowCheckingModeGuide == false {
            maskUIViewOne.frame = CGRect(x: startCheckingButton.frame.midX, y: startCheckingButton.frame.midY,
                                         width: 0, height: 0)
            UIView.animate(withDuration: 0.4, animations: {
                self.maskUIViewOne.frame = CGRect(
                    x: self.baseRadius * (1 - 4),
                    y: UIScreen.main.bounds.height / 2 - self.baseRadius * 4,
                    width: self.baseRadius * 8, height: self.baseRadius * 8
                )
                self.maskUIViewOne.layer.cornerRadius = self.baseRadius * 4
            })
            isShowCheckingModeGuide = true
            startCheckNSObj.startCheckingView.isUserInteractionEnabled = true
        } else {
            closeMaskViewOne()
        }
    }
    
    @objc func toggleMaskViewTwo() {
        if isShowQuizModeGuide == false {
            maskUIViewTwo.frame = CGRect(x: startQuizButton.frame.midX, y: startQuizButton.frame.midY, width: 0, height: 0)
            UIView.animate(withDuration: 0.4, animations: {
                self.maskUIViewTwo.frame = CGRect(
                    x: self.baseRadius * (1 - 4),
                    y: UIScreen.main.bounds.height / 2 - self.baseRadius * 4,
                    width: self.baseRadius * 8, height: self.baseRadius * 8
                )
                self.maskUIViewTwo.layer.cornerRadius = self.baseRadius * 4
            })
            isShowQuizModeGuide = true
            startQuizNSObj.startQuizView.isUserInteractionEnabled = true
        } else {
            closeMaskViewTwo()
        }
    }
    
    func closeMaskViewOne(){
        UIView.animate(withDuration: 0.5, animations: {
            self.maskUIViewOne.frame = CGRect(
                x: self.startCheckingButton.frame.midX,
                y: self.startCheckingButton.frame.midY,
                width: 0, height: 0)
            self.maskUIViewOne.layer.cornerRadius = 0
        })
        isShowCheckingModeGuide = false
        startCheckNSObj.startCheckingView.isUserInteractionEnabled = false
    }
    
    func closeMaskViewTwo(){
        UIView.animate(withDuration: 0.5, animations: {
            self.maskUIViewTwo.frame = CGRect(
                x: self.startQuizButton.frame.midX,
                y: self.startQuizButton.frame.midY,
                width: 0, height: 0)
            self.maskUIViewTwo.layer.cornerRadius = 0
        })
        isShowQuizModeGuide = false
        startQuizNSObj.startQuizView.isUserInteractionEnabled = false
    }

    @IBAction func startChecking(_ sender: Any) {
        toggleMaskViewOne()

//        performSegue(withIdentifier: "toCheckingMode", sender: nil)
    }
    
    @IBAction func startQuizButton(_ sender: Any) {
        toggleMaskViewTwo()
//        performSegue(withIdentifier: "toQuizViewSegue", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear")
    }
    
    @objc func segueToCheckingMode(){
        performSegue(withIdentifier: "toCheckingMode", sender: nil)
        closeMaskViewOne()
    }
    
    @objc func segueToQuizMode(){
        performSegue(withIdentifier: "toQuizViewSegue", sender: nil)
        closeMaskViewTwo()
    }
}

