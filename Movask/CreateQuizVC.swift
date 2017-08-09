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
    let questionCell = "QuizQuestionCell"
    
    var questions: [QuestionTest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = [defaultQuestion(), defaultQuestion(), defaultQuestion(), defaultQuestion(),defaultQuestion()]

        setupNavigationBar()
        setupCollectionView()
    }
    
    func defaultQuestion() -> QuestionTest {
        let qt = QuestionTest(type: .radiobuttons)
        qt.question = ""
        qt.answers = [AnswerTest(title: "")]
        return qt
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
        questions.append(defaultQuestion())
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCell, for: indexPath) as! QuizQuestionCell
        
        questions[indexPath.item].id = indexPath.item
        
        cell.question = questions[indexPath.item]
        cell.questionIndexLabel.text = "\(indexPath.item + 1)."
        cell.ownerCollectionView = quizCollectionView
        cell.delegate = self
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let item = collectionView.cellForItem(at: indexPath) as? QuizQuestionCell {
            let questionConteinerHeight = item.questionContainerHeight.constant + item.questionOptionsViewHeight.constant

            return CGSize(width: self.view.frame.width, height: questionConteinerHeight + 20)
        } else {
            return CGSize(width: self.view.frame.width, height: 186 + 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if UIApplication.shared.isLandscape {
            return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
//        guard let sourceItem = collectionView.cellForItem(at: sourceIndexPath) as? QuizQuestionCell else { return }
//        guard let destinationItem = collectionView.cellForItem(at: destinationIndexPath) as? QuizQuestionCell else { return }
//        
//        let tempQuestionIndex = sourceItem.questionIndexLabel.text
//        sourceItem.questionIndexLabel.text = destinationItem.questionIndexLabel.text
//        destinationItem.questionIndexLabel.text = tempQuestionIndex
        
    }
    
}

extension CreateQuizVC: QuizQuestionCellDelegate {
    
    func didTapDeleteQuestionButton(cell: QuizQuestionCell, sender: UIButton) {

        let point = quizCollectionView.convert(CGPoint.zero, from: sender)
        if let indexPath = quizCollectionView.indexPathForItem(at: point) {
            questions.remove(at: indexPath.item)

            self.quizCollectionView.performBatchUpdates({
                self.quizCollectionView.deleteItems(at: [indexPath])
            }, completion: { completed in
                self.quizCollectionView.reloadData()
            })
        }
    }
    
    func didFinishEditingQuestion(cell: QuizQuestionCell) {
        guard let question = cell.question else { return }
        questions[question.id].question = cell.questionTitleTextView.text
    }
    
}



