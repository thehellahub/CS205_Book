//  ViewController.swift
//  Quiz
//
//  Created by Nick Hella on 10/13/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = [
        "What is 7+7?",
        "What is the capital of Vermont?",
        "Is it peanut butter jelly time?"
    ]
    
    let answers: [String] = [
        "14",
        "Montpelier",
        "Damn straight, always is."
    ]
    
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
                currentQuestionIndex = 0
        }
        let question = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentQuestionLabel.text = questions[currentQuestionIndex]
    }
    
//    func animateLabelTransitions() {
//
//        // Animate the alpha
//        UIView.animate(withDuration: 0.5, animations: {
//            self.nextQuestionLabel.alpha = 1
//            self.currentQuestionLabel.alpha = 0
//        })
//    }
    
    func animateLabelTransitions() {
        UIView.animate(withDuration: 1.5,
            delay: 0,
            animations: {
                self.currentQuestionLabel.alpha = 0
                self.nextQuestionLabel.alpha = 1
            },
            completion: { (_ flag) -> Void in
                swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the question label's initial alpha
        nextQuestionLabel.alpha = 0
    }
}
