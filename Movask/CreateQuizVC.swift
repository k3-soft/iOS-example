//
//  CreateQuizVC.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class CreateQuizVC: BasicVC {
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    let headerCellPad = "CreateQuizHeaderCellPad"
    let headerCellPhone = "CreateQuizHeaderCellPhone"
    let questionCellPad = "CreateQuizQuestionCell"
    let questionCellPhone = "CreateQuizQuestionCellPhone"
    
    var questions: [QuestionPostTest] = []
    
    // Video
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        quizCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        header?.videoPlayer?.videoPlayerView.stopVideo()
    }
    
    // MARK: - Set views
    
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
        
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            quizCollectionView.register(UINib(nibName: questionCellPhone, bundle: nil),
                                        forCellWithReuseIdentifier: questionCellPhone)
            quizCollectionView.register(UINib(nibName: headerCellPhone, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellPhone)

        } else {
            quizCollectionView.register(UINib(nibName: questionCellPad, bundle: nil),
                                        forCellWithReuseIdentifier: questionCellPad)
            quizCollectionView.register(UINib(nibName: headerCellPad, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellPad)
        }
        
    }
    
    //MARK:- ACTIONS
    
    func saveTapped() {
        print("save tapped")
    }
    
    func addVideo(_ sender: UIButton) {
        showActionSheetForNewVideo(sender: sender)
    }
    
    @IBAction func didTapAddQuestion(_ sender: Any) {
        var q3 = QuestionPostTest(type: .gaps)
        
        switch arc4random_uniform(3) {
        case 0:
            q3 = QuestionPostTest(type: .gaps)
            q3.gapAnswer = "Tap plus signs to mark gap"
            q3.missingWordsIndexes = [1, 3]
        case 1:
            q3 = QuestionPostTest(type: .checkmarks)
            q3.question = "Why am I so stupid? Multiple choice!"
            q3.answers = []
        case 2:
            q3 = QuestionPostTest(type: .radiobuttons)
            q3.question = "Why am I so stupid? Single choice!"
            q3.answers = []
        default:
            break
        }
        
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
            var headerView = CreateQuizHeaderCell()
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellPhone, for: indexPath) as! CreateQuizHeaderCellPhone
            } else {
                headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellPad, for: indexPath) as! CreateQuizHeaderCell
            }
            
            headerView.addVideoHandler = { [unowned self] (sender) in
                self.addVideo(sender)
            }
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CreateQuizQuestionCell()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellPhone, for: indexPath) as! CreateQuizQuestionCellPhone
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellPad, for: indexPath) as! CreateQuizQuestionCell
        }
        
        questions[indexPath.item].id = indexPath.item
        
        cell.question = questions[indexPath.item]
        cell.ownerCollectionView = quizCollectionView
        cell.delegate = self
        cell.answersView.modificationDelegate = self
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let shadowSize: CGFloat = 10.0
        var cellHeight: CGFloat = 0
        let iphoneTopButtonsHeight: CGFloat = 50 + 16
        
        if let questionCell = collectionView.cellForItem(at: indexPath) as? CreateQuizQuestionCell {
            if UIDevice.current.userInterfaceIdiom == .phone {
                cellHeight = questionCell.questionContainerHeight.constant + questionCell.answersViewHeight.constant + shadowSize + iphoneTopButtonsHeight
            } else {
                cellHeight = questionCell.questionContainerHeight.constant + questionCell.answersViewHeight.constant + shadowSize
            }
            return CGSize(width: self.view.frame.width, height: cellHeight)
            
        } else {
            return sizeFor(question: questions[indexPath.item])
        }
    }
    
    func sizeFor(question: QuestionPostTest) -> CGSize {
        
        let shadowSize: CGFloat = 10.0
        let answersFooterHeight: CGFloat = 33.0 // add item button
        let answersCollectionViewInsets: CGFloat = 16.0
        let textViewInsets: CGFloat = 16.0
        var answersConteinerHeight: CGFloat = answersFooterHeight + answersCollectionViewInsets
        
        var minCellHeight: CGFloat = 0 // height for green question block without textview
        var questionTextViewWidth: CGFloat = 0
        var answerTextViewWidth: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            minCellHeight = 80 + 50 + 16
            questionTextViewWidth = self.view.frame.width - 16 - 16
            answerTextViewWidth = self.view.frame.width - 25 - 16 - 8
        } else {
            minCellHeight = 80
            questionTextViewWidth = self.view.frame.width - 50 - 50 - 16 - 16 - 16
            answerTextViewWidth = self.view.frame.width - 50 - 50 - 16 - 16 - 25 - 16 - 8
        }
        
        switch question.type {
        case .gaps:
            // question textview that should be same as used in cell
            let questionTextViewHeight = question.gapAnswer.height(withFixedWidth: questionTextViewWidth, textAttributes: CreateQuizQuestionCell.gapsQuestionTextAttributes)
            let questionContainerHeight = questionTextViewHeight + textViewInsets + minCellHeight
            return CGSize(width: self.view.frame.width, height: CGFloat(questionContainerHeight + shadowSize))
            
        case .checkmarks, .radiobuttons:
            // question textview that should be same as used in cell
            let questionTextViewHeight = question.question.height(withFixedWidth: questionTextViewWidth, textAttributes: CreateQuizQuestionCell.variantsQuestionTextAttributes) + textViewInsets
            
            let questionContainerHeight = questionTextViewHeight + minCellHeight
            
            // calculate size for each answer
            for answer in question.answers {
                let answerTextViewHeight = answer.title.height(withFixedWidth: answerTextViewWidth, textAttributes: CreateQuizQuestionCell.variantsQuestionTextAttributes) + textViewInsets
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: self.view.frame.width, height: 470)
        } else {
            return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        questions.rearrange(from: sourceIndexPath.item, to: destinationIndexPath.item)
    }
    
    var header: CreateQuizHeaderCell? {
        
        if let header = quizCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? CreateQuizHeaderCell {
            return header
        } else {
            return nil
        }
    }
}

extension CreateQuizVC: QuizQuestionCellDelegate {
    
    func didTapDeleteQuestionButton(cell: CreateQuizQuestionCell, sender: UIButton) {
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
    
    func didFinishEditingQuestion(cell: CreateQuizQuestionCell) {
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

extension CreateQuizVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showActionSheetForNewVideo(sender: UIView) {
        
        let videoMenu = UIAlertController(title: nil, message: "Select video source", preferredStyle: .actionSheet)
        
        let pickFromGallery = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.showImagePicker(sourceType: .photoLibrary)
        })
        
        let makeVideo = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.showImagePicker(sourceType: .camera)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        videoMenu.addAction(pickFromGallery)
        videoMenu.addAction(makeVideo)
        videoMenu.addAction(cancelAction)
        
        // Setting for IPad
        if let popoverController = videoMenu.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(videoMenu, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.videoQuality = .typeMedium
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let fileURL = info[UIImagePickerControllerMediaURL] as? URL {
            VideoManager.getOriginalVideoResolution(url: fileURL, completionHandler: { [weak self](url) in
                DispatchQueue.main.async {
                    self?.videoURL = url
                    self?.header?.setVideoPlayer(url: url)
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

