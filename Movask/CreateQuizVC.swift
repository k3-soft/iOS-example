//
//  CreateQuizVC.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class CreateQuizVC: BasicVC {
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    let headerCell = "QuizHeaderCell"
    let questionCell = "QuizQuestionAnswersCell"
    
    var questions: [QuestionPostTest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addQuestions()
        setupNavigationBar()
        setupCollectionView()
    }
    
    func addQuestions() {
        let q1 = QuestionPostTest(type: .checkmarks)
        q1.question = "Who is your daddy?"
        q1.answers = [AnswerTest(title: "Me", isCorrect: false), AnswerTest(title: "You", isCorrect: false), AnswerTest(title: "Nobody", isCorrect: false), AnswerTest(title: "shit", isCorrect: false)]
        
        let q2 = QuestionPostTest(type: .radiobuttons)
        q2.question = "Why am I so stupid?"
        q2.answers = [AnswerTest(title: "Because", isCorrect: false), AnswerTest(title: "Who knows", isCorrect: false), AnswerTest(title: "You are not", isCorrect: false)]
        
        let q3 = QuestionPostTest(type: .gaps)
        q3.question = "Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?Why am I so stupid?"
        q3.answers = []
        q3.gapAnswer = "You shall not pass, bitch"
        q3.missingWordsIndexes = [1, 3, 6, 7, 23, 21, 15]
        
        let q4 = QuestionPostTest(type: .checkmarks)
        q4.question = "Who is your daddy?"
        q4.answers = [AnswerTest(title: "Me", isCorrect: false), AnswerTest(title: "You You You You You You You You You You You You You You You You You You You You You You You You You You You You You You You You ", isCorrect: false), AnswerTest(title: "Nobody", isCorrect: false), AnswerTest(title: "shit", isCorrect: false)]
        
        let q5 = QuestionPostTest(type: .radiobuttons)
        q5.question = "Why am I so stupid? Tell me"
        q5.answers = [AnswerTest(title: "Because", isCorrect: false), AnswerTest(title: "Who knows", isCorrect: false), AnswerTest(title: "You are not", isCorrect: false), AnswerTest(title: "You are not", isCorrect: false), AnswerTest(title: "You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not ", isCorrect: false)]
        
        let q6 = QuestionPostTest(type: .gaps)
        q6.question = "Why am I so stupid?"
        q6.answers = []
        q6.gapAnswer = "You shall not pass, bitch, hello you ar q6 ou shall not pass, bitch, hello you ar q6, ou shall not pass, bitch, hello you ar q6, ou sha You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You arll not pass, bitch, hello you ar q6ou shall not pass, bitch, hello you ar q6"
        q6.missingWordsIndexes = [1, 4, 6, 7, 23, 21, 15, 13, 19]
        
        let q7 = QuestionPostTest(type: .radiobuttons)
        q7.question = "Why am I so stupid?"
        q7.answers = []
        
        questions = [q2, q6, q3, q4, q5, q1, q7]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        quizCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isTranslucent = false
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.title = "Quiz Maker"
    }
    
    func setupCollectionView() {
        quizCollectionView.delegate = self
        quizCollectionView.dataSource = self
        
        quizCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        automaticallyAdjustsScrollViewInsets = false

        let flow = quizCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionHeadersPinToVisibleBounds = true
        
        quizCollectionView.register(UINib(nibName: questionCell, bundle: nil),
                                    forCellWithReuseIdentifier: questionCell)
        quizCollectionView.register(UINib(nibName: headerCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCell)
    }

    
    //MARK:- ACTIONS
    
    func saveTapped() {
        print("save tapped")
    }
    
    @IBAction func didTapAddQuestion(_ sender: Any) {
        let q3 = QuestionPostTest(type: .gaps)
        q3.question = "Why am I so stupid?"
        q3.answers = []
        q3.gapAnswer = "You shall not pass, bitch"
        q3.missingWordsIndexes = [1, 3]
        
//        let q5 = QuestionPostTest(type: .radiobuttons)
//        q5.question = "Why am I so stupid? Tell me"
//        q5.answers = [AnswerTest(title: "Because", isCorrect: false), AnswerTest(title: "Who knows", isCorrect: false), AnswerTest(title: "You are not", isCorrect: false), AnswerTest(title: "You are not", isCorrect: false), AnswerTest(title: "You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not You are not ", isCorrect: false)]
        
        questions.append(q3)
        
        quizCollectionView.performBatchUpdates({
            self.quizCollectionView.insertItems(at: [IndexPath(item: self.questions.count - 1, section: 0)])
        }, completion: { completed in
            self.quizCollectionView.scrollToItem(at: IndexPath(item: self.questions.count - 1, section: 0), at: .top, animated: true)
        })
    }
    
}


extension CreateQuizVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as! QuizHeaderCell
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCell, for: indexPath) as! QuizQuestionAnswersCell
        
        questions[indexPath.item].id = indexPath.item
        
        cell.question = questions[indexPath.item]
        cell.ownerCollectionView = quizCollectionView
        cell.delegate = self
        cell.answersView.modificationDelegate = self
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let questionCell = collectionView.cellForItem(at: indexPath) as? QuizQuestionAnswersCell {
            let shadowSize: CGFloat = 10.0
            let cellHeight = questionCell.questionContainerHeight.constant + questionCell.answersViewHeight.constant
            return CGSize(width: self.view.frame.width, height: cellHeight + shadowSize)
            
        } else {
            return sizeFor(question: questions[indexPath.item])
        }
    }
    
    func sizeFor(question: QuestionPostTest) -> CGSize {
        let questionBlockHeight: CGFloat = 80 // height for green question block without textview
        let shadowSize: CGFloat = 10.0
        let answersFooterHeight: CGFloat = 33.0 // add item button
        let answersCollectionViewInsets: CGFloat = 16.0
        let textViewInsets: CGFloat = 16.0
        var answersConteinerHeight: CGFloat = answersFooterHeight + answersCollectionViewInsets
        
        let questionTextViewWidth: CGFloat = self.view.frame.width - 50 - 50 - 16 - 16 - 16
        let answerTextViewWidth: CGFloat = self.view.frame.width - 50 - 50 - 16 - 16 - 25 - 16 - 8
        
        switch question.type {
        case .gaps:
            // question textview that should be same as used in cell
            let questionTextViewHeight = question.gapAnswer.height(withFixedWidth: questionTextViewWidth, textAttributes: QuizQuestionAnswersCell.gapsQuestionTextAttributes)
            let questionContainerHeight = questionTextViewHeight + textViewInsets + questionBlockHeight
            
            return CGSize(width: self.view.frame.width, height: CGFloat(questionContainerHeight + shadowSize))
            
        case .checkmarks, .radiobuttons:
            // question textview that should be same as used in cell
            let questionTextViewHeight = question.question.height(withFixedWidth: questionTextViewWidth, textAttributes: QuizQuestionAnswersCell.variantsQuestionTextAttributes) + textViewInsets
            
            let questionContainerHeight = questionTextViewHeight + questionBlockHeight
            
            // calculate size for each answer
            for answer in question.answers {
                let answerTextViewHeight = answer.title.height(withFixedWidth: answerTextViewWidth, textAttributes: QuizQuestionAnswersCell.variantsQuestionTextAttributes) + textViewInsets
                print(answerTextViewHeight)
                answersConteinerHeight += answerTextViewHeight
            }
            
            return CGSize(width: self.view.frame.width, height: questionContainerHeight + answersConteinerHeight + shadowSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if UIApplication.shared.isLandscape {
            return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        questions.rearrange(from: sourceIndexPath.item, to: destinationIndexPath.item)
    }
    
}

extension CreateQuizVC: QuizQuestionCellDelegate {
    
    func didTapDeleteQuestionButton(cell: QuizQuestionAnswersCell, sender: UIButton) {
        let point = quizCollectionView.convert(CGPoint.zero, from: sender)
        
        if let indexPath = quizCollectionView.indexPathForItem(at: point) {
            self.questions.remove(at: indexPath.item)
            
            self.quizCollectionView.performBatchUpdates({
                self.quizCollectionView.deleteItems(at: [indexPath])
            }, completion: { completed in
                self.quizCollectionView.reloadData()
//                self.quizCollectionView.collectionViewLayout.invalidateLayout()
                
            })
        }
    }
    
    func didFinishEditingQuestion(cell: QuizQuestionAnswersCell) {
        guard let question = cell.question else { return }
        guard question.id < questions.count else { return }

        switch question.type {
        case .checkmarks,.radiobuttons:
            questions[question.id].question = cell.questionTitleTextView.text
        case .gaps:
            questions[question.id].gapAnswer = cell.questionTitleTextView.text
        }
        
    }
    
}

extension CreateQuizVC: AnswersViewModificationDelegate {
    
    func didFinishEditing(answer: AnswerTest, for question: QuestionPostTest?, withText text: String) {

        guard let question = question else { return }
        guard question.id < questions.count else { return }
        
        let questionToModify = questions[question.id]
        
        for oldAnswer in questionToModify.answers {
            if oldAnswer === answer {
                oldAnswer.title = text
            }
        }
    }
    
    func didSelect(answer: AnswerTest, for question: QuestionPostTest?) {
        guard let question = question else { return }
        guard question.id < questions.count else { return }
        
        let questionToModify = questions[question.id]
        
        switch question.type {
        case .checkmarks:
            for oldAnswer in questionToModify.answers {
                if oldAnswer === answer {
                    oldAnswer.isSelected = answer.isSelected
                }
            }
        case .radiobuttons:
            for oldAnswer in questionToModify.answers {
                if oldAnswer === answer {
                    oldAnswer.isSelected = true
                } else {
                    oldAnswer.isSelected = false
                }
            }
        default: break
        }
        
    }
    
    func didAdd(answer: AnswerTest, for question: QuestionPostTest?) {
        guard let question = question else { return }
        guard question.id < questions.count else { return }
        
        let questionToModify = questions[question.id]
        questionToModify.answers.append(answer)
    }
    
}



