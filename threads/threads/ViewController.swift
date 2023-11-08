//
//  ViewController.swift
//  threads
//
//  Created by Levan Loladze on 08.11.23.
//

import UIKit

class ViewController: UIViewController {
    
    
    let centeredStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    let firstNumLabel: UILabel = {
        let label = UILabel()
        label.text = "First Number"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let secondNumLabel: UILabel = {
        let label = UILabel()
        label.text = "Second Number"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let winningLabel: UILabel = {
        let label = UILabel()
        label.text = "Winning Thread"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let factorialButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupUI()
    }
    
    
    func setupUI() {
        view.addSubview(centeredStackView)
        
        centeredStackView.addArrangedSubview(firstNumLabel)
        centeredStackView.addArrangedSubview(secondNumLabel)
        centeredStackView.addArrangedSubview(winningLabel)
        centeredStackView.addArrangedSubview(factorialButton)
        
        NSLayoutConstraint.activate([
            centeredStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centeredStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            centeredStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80)
        ])
        
        factorialButton.addTarget(self, action: #selector(factorialButtonClicked(_:)), for: .touchUpInside)
        
    }
    
    @objc func factorialButtonClicked(_ sender: UIButton) {
        
        func factorial(of number: Int, completion: @escaping (Int) -> Void) {
            DispatchQueue.global().async {
                var result = 1
                if number == 0 {
                    completion(result)
                } else {
                    for i in 1...number {
                        result *= i
                    }
                    completion(result)
                }
            }
        }
        
        func generateRandomNumbers() -> Int {
            let fromNumber = 0
            let toNumber = 10
            let randomNum1 = Int(arc4random_uniform(UInt32(toNumber - fromNumber))) + fromNumber
            return randomNum1
        }
        
        func findWinnerThread(completion: @escaping (String) -> Void) {
            let number1 = generateRandomNumbers()
            let number2 = generateRandomNumbers()
            
            firstNumLabel.text = "First Number: " + String(number1)
            secondNumLabel.text = "Second Number: " + String(number2)
            
            factorial(of: number1) { factorial1 in
                factorial(of: number2) { factorial2 in
                    let winner: Int
                    if factorial1 > factorial2 {
                        winner = number1
                    } else if factorial2 > factorial1 {
                        winner = number2
                    } else {
                        winner = number1
                    }
                    
                    completion("Winner thread: Factorial of \(winner) - \(max(factorial1, factorial2))")
                }
            }
        }
        
        findWinnerThread { result in
            DispatchQueue.main.async {
                self.winningLabel.text = result
            }
        }
        
    }
    
}

