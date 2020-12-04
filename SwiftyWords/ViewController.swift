//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Mahmoud Nasser on 02/12/2020.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel : UILabel!
    var answersLabel : UILabel!
    var currentAnswerTF : UITextField!
    var scoreLabel : UILabel!
    var lettersBtns = [UIButton]()
    var tappedButtons = [UIButton]()
    
    var score:Int = 0{
        didSet{
            scoreLabel.text = String("score: \(score)")
        }
    }
    var solutions = [String]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.text = "Clues"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
//        cluesLabel.backgroundColor = .orange
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.text = "Answers"
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
//        answersLabel.backgroundColor = .red
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answersLabel)
        
        currentAnswerTF = UITextField()
        currentAnswerTF.font = UIFont.systemFont(ofSize: 44)
        currentAnswerTF.placeholder = "Tap letter to guess"
        currentAnswerTF.isUserInteractionEnabled = false
        currentAnswerTF.textAlignment = .center
        currentAnswerTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentAnswerTF)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.blue, for: .normal)
        submitButton.addTarget(self, action: #selector(submitBtnTapped(_:)), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.blue, for: .normal)
        clearButton.addTarget(self, action: #selector(clearBtnTapped(_:)), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        
        let btnsContainer = UIView()
        btnsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnsContainer)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4,constant: -100),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 0.6,constant: -100),
            cluesLabel.heightAnchor.constraint(equalTo: answersLabel.heightAnchor),
            
            currentAnswerTF.topAnchor.constraint(equalTo: cluesLabel.layoutMarginsGuide.bottomAnchor, constant: 20),
            currentAnswerTF.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswerTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswerTF.bottomAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -100),
            
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor ,constant: 100),
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            
            btnsContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor ,constant: 20),
            btnsContainer.heightAnchor.constraint(equalToConstant: 320),
            btnsContainer.widthAnchor.constraint(equalToConstant: 750),
            btnsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnsContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        
        let width = 150
        let height = 80
        
        for column in 0..<5{
            for row in 0..<4{
                let button = UIButton(type: .system)
                button.setTitle("MMM", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
                button.addTarget(self, action: #selector(letterBtnTapped(_:)), for: .touchUpInside)
//                button.backgroundColor = .gray
                let frame = CGRect(x: width * column, y: height * row , width: width, height: height)
                button.frame = frame
                
                btnsContainer.addSubview(button)
                lettersBtns.append(button)
            }
        }
        
//        btnsContainer.backgroundColor = .green
    }
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel(level: 1)
    }
    
    //MARK:- Functions
    
    func loadLevel(level:Int){
        
        var clueString :String = ""
        var solutionString = ""
        var letterBits = [String]()
        
//        var clues = [String]()
//        var solutions = [String]()
//        var solutionsLettersCount = [Int]()
        
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            print("no level url found")
            return
        }
        
        guard let levelContents = try? String(contentsOf: levelURL) else {
            print("couldnt find contents for url")
            return
        }
        
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()
        
        for (index,line) in lines.enumerated(){
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            
            clueString += "\(index + 1). \(clue)\n"
            
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            solutionString += "\(solutionWord.count) letters\n"
            solutions.append(solutionWord)
            
            let bits = answer.components(separatedBy: "|")
            letterBits += bits
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        lettersBtns.shuffle()
        
        if lettersBtns.count == letterBits.count{
            for i in 0..<letterBits.count{
                lettersBtns[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
        /*
        for line in lines{
            let lineComponent = line.components(separatedBy: ": ")
            clues.append(lineComponent[1])
            solutions.append(lineComponent[0])
        }
        for solution in solutions {
            let solution = solution.replacingOccurrences(of: "|", with: "")
            solutionsLettersCount.append(solution.count)
        }
        print(clues,solutions,solutionsLettersCount)
        */
    }
    
    //MARK:- objective C Functions
    
    @objc func clearBtnTapped(_ sender:UIButton){
        currentAnswerTF.text = ""
        
        for btn in tappedButtons{
            btn.isHidden = false
        }
        
        tappedButtons.removeAll()
        
    }
    
    @objc func submitBtnTapped(_ sender:UIButton){
        guard let answerText = currentAnswerTF.text else {return}
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            tappedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswerTF.text = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "WellDone!", message: "Are you ready for the next Level", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "ok", style: .default,handler: levelUp)
                
                let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                
                ac.addAction(okAction)
                ac.addAction(cancel)
                
                present(ac, animated: true, completion: nil)
                
            }
            
        }
        
        
        
      //  array.containway
        /*
        if solutions.contains(currentAnswerTF.text!){
            print("right answer")
        }else {
            print("wrong answer")
        }
        */
        
//        loopsWay
        /*
         for solution in solutions {
            if solution == currentAnswerTF.text {
                print("right answer")
            }else {
                print("wrong answer")
            }
        }
         */
        
    }
    
    @objc func letterBtnTapped(_ sender:UIButton){
        guard let buttonTitle = sender.title(for: .normal) else {return}
        currentAnswerTF.text! += buttonTitle
        tappedButtons.append(sender)
        sender.isHidden = true
    }
    
    func levelUp(action:UIAlertAction){
        solutions.removeAll(keepingCapacity: true)
        loadLevel(level: 2)
        
        for btn in lettersBtns {
            btn.isHidden = false
        }
    }
}

