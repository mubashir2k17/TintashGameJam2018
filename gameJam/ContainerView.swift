//
//  ContainerView.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

enum RelativePositionToCharacter { // Used to give position of a card relative to the position of our character e.g. if Right, then the position of the card in question is on the right column of the character
    case Right
    case Left
    case Above
    case Below
    case None
}

class ContainerView: UIView {

    var characterPosition : (rowNum : Int, columnNum : Int) = (0,0)
    var cardsBtnArray = [Int : CardView]()
    var tileFramesArray = [Int : CGPoint]()
    var characterCard : CardView = CardView()
    
    func populateTimeFrames() {
        let cardWidth = 103
        let cardHeight = 136
        
        for i in 0..<9 {
            let pos = getPosition(fromIndex: i)
            let x = pos.columnNum * cardWidth
            let y = pos.rowNum * cardHeight
            let pont = CGPoint(x: x, y: y)
            tileFramesArray[i] = pont
        }
    }
    
    func canPerformAction(onCardPosition cardPos : (rowNum : Int, columnNum : Int)) -> Bool {
        
        var canPerform = false
        let anchorRow = characterPosition.rowNum
        let anchorCol = characterPosition.columnNum
        let tappedCardRow = cardPos.rowNum
        let tappedCardCol = cardPos.columnNum
        if(tappedCardRow - 1 == anchorRow || tappedCardRow + 1 == anchorRow) {
            canPerform = true
        }
        if(tappedCardCol - 1 == anchorCol || tappedCardCol + 1 == anchorCol) {
            canPerform = true
        }
        return canPerform
    }
    
    func getIndex(fromPosition pos : (rowNum : Int, columnNum : Int)) -> Int {
        return pos.rowNum * 3 + pos.columnNum
    }
    
    func getPosition(fromIndex index : Int) -> (rowNum : Int, columnNum : Int) {
        let row : Int = index / 3
        let col : Int = index % 3
        return (row, col)
    }
    
    func cardTapped(card : CardView) {
        
        let canPerform = canPerformAction(onCardPosition: card.position)
        if(canPerform) {
            card.die(withCompletion: { () in
                let character = self.characterCard
                let characterNeedsToMoveTo = self.getCardPositionRelativeToCharacter(cardPos: card.position)
                if(characterNeedsToMoveTo == .Right) {
                    character.moveRight()
                }
                else if(characterNeedsToMoveTo == .Left) {
                    character.moveRight()
                }
                else if(characterNeedsToMoveTo == .Above) {
                    character.moveUp()
                }
                else if(characterNeedsToMoveTo == .Below) {
                    character.moveDown()
                }
                
                let columnNum = character.position.columnNum
                let rowNum = character.position.rowNum
                
                if(characterNeedsToMoveTo == .Right || characterNeedsToMoveTo == .Left) { // moved to a different column
                    if(rowNum == 0) {
                        for i in rowNum..<1 {
                            let toIndex = self.getIndex(fromPosition: (rowNum: i, columnNum: columnNum))
                            let fromIndex = self.getIndex(fromPosition: (rowNum: i+1, columnNum: columnNum))
                            
                            let fromCard = self.cardsBtnArray[fromIndex]
                            let toFrame = self.tileFramesArray[toIndex]
                            fromCard?.frame.origin = toFrame!
                            
                            self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                        }
                    }
                    else if(rowNum == 1) {
                        let diceRoll = Int(arc4random_uniform(1))
                        let change = diceRoll == 0 ? 1 : -1
                        let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: columnNum))
                        let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum+change, columnNum: columnNum))
                        self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                    }
                    else if(rowNum == 2) {
                        var i = rowNum
                        while i-1 > 0 {
                            let toIndex = self.getIndex(fromPosition: (rowNum: i, columnNum: columnNum))
                            i -= 1
                            let fromIndex = self.getIndex(fromPosition: (rowNum: i, columnNum: columnNum))
                            self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                        }
                    }
                }
                else if(characterNeedsToMoveTo == .Above || characterNeedsToMoveTo == .Below) { // moved to a different row
                    if(columnNum == 0) {
                        for i in columnNum..<1 {
                            let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i))
                            let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i+1))
                            self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                        }
                    }
                    if(columnNum == 1) {
                        let diceRoll = Int(arc4random_uniform(1))
                        let change = diceRoll == 0 ? 1 : -1
                        let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: columnNum))
                        let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: columnNum+change))
                        self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                    }
                    if(columnNum == 2) {
                        var i = columnNum
                        while i-1 > 0 {
                            let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i))
                            i -= 1
                            let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i))
                            self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                        }
                    }
                }
            })
        }
    }
    
    func getCardPositionRelativeToCharacter(cardPos : (rowNum : Int, columnNum : Int)) -> RelativePositionToCharacter {
        
        var posEnum = RelativePositionToCharacter.None
        let anchorRow = characterPosition.rowNum
        let anchorCol = characterPosition.columnNum
        
        if(cardPos.rowNum - 1 == anchorRow) {
            posEnum = .Below
        }
        else if(cardPos.rowNum + 1 == anchorRow) {
            posEnum = .Above
        }
        else if(cardPos.columnNum - 1 == anchorCol) {
            posEnum = .Right
        }
        else if(cardPos.columnNum + 1 == anchorCol) {
            posEnum = .Left
        }
        return posEnum
    }
    
    
}
