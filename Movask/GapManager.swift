//
//  GapManager.swift
//  Movask
//
//  Created by Alina Yehorova on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class GapManager {
    
    func buildGap(text: String, missingWordsIndexes: [Int]) -> (resultText: String, missingWords: [String]) {
        
        var gapComponents = text.components(separatedBy: " ")
        var missingWords = [String]()
        
        for index in missingWordsIndexes {
            guard index < gapComponents.count else { continue }
            
            let wordToHide: NSString = gapComponents[index] as NSString
            
            // Check if word has punctuation mark at the end (we have not replace it with "_")
            
            let lastCharacter: NSString = wordToHide.substring(from: wordToHide.length - 1) as NSString
            var punctuationAtTheEnd = false
            
            let punctuationsSet = CharacterSet(charactersIn: "?!,.:;")
            if lastCharacter.rangeOfCharacter(from: punctuationsSet).location != NSNotFound {
                punctuationAtTheEnd = true
            }
            
            // Compose hidden word with "_____" and add punctuation mark at the end (if needed)
            
            let numberOfLetters = wordToHide.length - (punctuationAtTheEnd ? 1 : 0)
            var hiddenWord = String(repeatElement("_", count: numberOfLetters))
            hiddenWord += punctuationAtTheEnd ? lastCharacter as String : ""
            
            // Save hidden word without punctuation mark
            
            if punctuationAtTheEnd {
                let wordWithoutPunctuation: NSString = wordToHide.substring(to: wordToHide.length - 1) as NSString
                missingWords.append(wordWithoutPunctuation as String)
                
            } else {
                missingWords.append(wordToHide as String)
            }
            
            // Replace word for label text
            
            gapComponents[index] = hiddenWord
        }
        
        let resultText = gapComponents.joined(separator: " ")
        
        return (resultText, missingWords)
    }
    
    func getRangesOfGaps(in textView: UITextView, missingWords: [String]) -> [NSRange] {
        
        let text = textView.text! as NSString
        var textRange = NSMakeRange(0, text.length)
        
        var gapRanges = [NSRange]()
        
        for word in missingWords {
            
            // Find next "_" in text
            
            let wordLength = word.characters.count
            let range: NSRange = text.range(of: "_", options: .caseInsensitive, range: textRange)
            
            if range.location != NSNotFound {
                // When it was found - get range of this word
                let wordRange = NSMakeRange(range.location, wordLength)
                gapRanges.append(wordRange)
                
                // Cut already looked text for next iteration
                textRange = NSMakeRange(wordRange.location + wordLength, text.length - (wordRange.location + wordLength))
            }
        }
        
        return gapRanges
    }
    
    func boundingRectForCharacterRange(in textView: UITextView, range: NSRange) -> CGRect {
       
        let glyphRange = textView.layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        
        if let glyphContainer = textView.layoutManager.textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) {
            return textView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: glyphContainer)
        } else {
            return .zero
        }
    }
}
