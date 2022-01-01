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
    
    @IBOutlet weak var animationView: UIView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear")
        createCircle()
    }
    
    func createCircle() {
        
        // animationTest
//        let path = UIBezierPath()
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 50, startAngle: 0, endAngle: 4, clockwise: true)
        UIColor.clear.setFill()
//        path.fill()
//        path.move(to: CGPoint(x: animationView.frame.maxX, y: animationView.frame.minY))
//        path.addLine(to: CGPoint(x: animationView.frame.minX, y: animationView.frame.maxY))
//        path.lineWidth = 2.0
        
        let lineLayer = CAShapeLayer()
        lineLayer.fillColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0)
        lineLayer.strokeColor = UIColor(named: "mainColorLight")!.cgColor
        lineLayer.lineWidth = 5.0
        lineLayer.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        
//        view.layer.addSublayer(lineLayer)
        lineLayer.add(animation, forKey: nil)
        animationView.backgroundColor = .gray
        animationView.layer.addSublayer(lineLayer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("viewDidDisappear")
//        animationView.removeFromSuperview()
    }
}

