//
//  ResultQuestionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class ResultQuestionCell: UICollectionViewCell {
    
    // Labels
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    // Constraints
    @IBOutlet weak var heightQuestionLabel: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: NSLayoutConstraint!
    
    // Data
    var question: QuestionGetTest?
    
    // Sizes
    
    let heightQuestionViewWithoutLabel: CGFloat = 45.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 360.0
        } else {
            return 453.0
        }
    }
    
    var cellSideInsets: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 44.0
        } else {
            return 260.0
        }
    }
    
    // Font
    
    var font: (size: CGFloat, name: String) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return (16.0, "Solomon-Sans-SemiBold")
        } else {
            return (18.0, "Solomon-Sans-Bold")
        }
    }
    
    // TableView
    
    @IBOutlet weak var answersTableView: UITableView!
    
    let cellIdentifier = "AnswerSelectionCell"
    
    // MARK: - Set cell
    
    func reload(viewWidth: CGFloat) {
        setLabelHeight(cellWidth: viewWidth - cellSideInsets)
    }
    
    func setWithQuestion(_ question: QuestionGetTest) {
        
        self.question = question
        
        setAnswersTableView()
        setLabelHeight(cellWidth: bounds.width)
        
        // Set labels
        
        questionLabel.text = question.question
        instructionLabel.text = question.type.instruction
    }
    
    func setLabelHeight(cellWidth: CGFloat) {
        
        guard question != nil else { return }
        
        let height = question!.question.textHeightWithFont(size: font.size, name: font.name, viewWidth: cellWidth, offset: 0.0)
        
        heightQuestionLabel.constant = height
        heightQuestionView.constant = height + heightQuestionViewWithoutLabel
    }
    
    func setAnswersTableView() {
        
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        answersTableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                  forCellReuseIdentifier: cellIdentifier)
        
        answersTableView.reloadData()
    }
}

extension ResultQuestionCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question!.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnswerSelectionCell
        
        cell.type = question?.type
        cell.setWithAnswer(question!.answers[indexPath.row], showResults: true)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let answer = question!.answers[indexPath.row]
        
        switch question!.type {
        case .checkmarks, .radiobuttons:
            return AnswerSelectionCell.getCellHeightFor(viewWidth: bounds.width, answer: answer)
            
        case .gaps:
            return 0.0
        }
    }
}
