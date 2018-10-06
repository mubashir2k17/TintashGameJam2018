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
    var cardsFramesArray = [Int : CGPoint]()
    var characterCard : CardView = CardView()
    let screenWidth = UIScreen.main.bounds.width
    
    func populateTimeFrames() {
        let cardWidth = 103
        let cardHeight = 136
        
        for i in 0..<9 {
            let pos = getPosition(fromIndex: i)
            let x = pos.columnNum * cardWidth
            let y = pos.rowNum * cardHeight
            let pont = CGPoint(x: x, y: y)
            cardsFramesArray[i] = pont
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

    func initializeGrid() {
        
        let cardDidPress: ((CardView) -> Void) = { [weak self](card) in
            self?.cardTapped(card: card)
        }
        populateTimeFrames()
        
        cardsBtnArray[0] = CardView(frame: CGRect(x: 0, y: 0, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[1] = CardView(frame: CGRect(x: 103, y: 0, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[2] = CardView(frame: CGRect(x: 206, y: 0, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[3] = CardView(frame: CGRect(x: 0, y: 136, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[4] = CardView(frame: CGRect(x: 103, y: 136, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[5] = CardView(frame: CGRect(x: 206, y: 136, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[6] = CardView(frame: CGRect(x: 0, y: 272, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[7] = CardView(frame: CGRect(x: 103, y: 272, width: 103, height: 136), cardDidPress: cardDidPress)
        cardsBtnArray[8] = CardView(frame: CGRect(x: 206, y: 272, width: 103, height: 136), cardDidPress: cardDidPress)
        
        for num in 0..<9 {
            cardsBtnArray[num]?.center.x -= screenWidth
            self.addSubview(cardsBtnArray[num]!)
        }
    }
    
    func createCard(atPosition cardPos : (rowNum : Int, columnNum : Int)) {
        
        let index = getIndex(fromPosition: cardPos)
        let origin = cardsFramesArray[index]
        let size = CGSize(width: 103, height: 136)
        let rect = CGRect(origin: origin!, size: size)
        cardsBtnArray[index] = CardView(frame: rect)
        cardsBtnArray[index]?.center.x -= screenWidth
        self.addSubview(cardsBtnArray[index]!)
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.curveEaseOut],
                       animations: {
                        self.cardsBtnArray[index]?.center.x += self.screenWidth
        },
                       completion: { (true) in
                        
        })
        
    }
    
    func loadGridWithAnimation(index : Int) {
        
        if(index > 8) {
            return
        }
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.curveEaseOut],
                       animations: {
                        self.cardsBtnArray[index]?.center.x += self.screenWidth
                        },
                       completion: { (true) in
                        self.loadGridWithAnimation(index: index + 1)
                        })
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
                character.move(toOrigin: card.frame.origin, completion: { () in
                    
                    let columnNum = character.position.columnNum
                    let rowNum = character.position.rowNum
                    var openIndex : (rowNum : Int, columnNum : Int) = (0,0)
                    
                    if(characterNeedsToMoveTo == .Right || characterNeedsToMoveTo == .Left) { // moved to a different column
                        if(rowNum == 0) {
                            for i in rowNum..<1 {
                                let toIndex = self.getIndex(fromPosition: (rowNum: i, columnNum: columnNum))
                                let fromIndex = self.getIndex(fromPosition: (rowNum: i+1, columnNum: columnNum))
                                
                                let fromCard = self.cardsBtnArray[fromIndex]
                                let toFrame = self.cardsFramesArray[toIndex]
                                fromCard?.move(toOrigin: toFrame!)
                                //                            fromCard?.frame.origin = toFrame! // TODO: Animate to this frame in all if checks below as well
                                self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                                openIndex = (rowNum: i+1, columnNum: columnNum) // TODO: Set open index below as well and insert card at this frame and then in the cards array as well
                            }
                        }
                        else if(rowNum == 1) {
                            let diceRoll = Int(arc4random_uniform(1))
                            let change = diceRoll == 0 ? 1 : -1
                            let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: columnNum))
                            let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum+change, columnNum: columnNum))
                            
                            let fromCard = self.cardsBtnArray[fromIndex]
                            let toFrame = self.cardsFramesArray[toIndex]
                            fromCard?.move(toOrigin: toFrame!)
                            
                            self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                            
                            openIndex = (rowNum: rowNum+change, columnNum: columnNum)
                        }
                        else if(rowNum == 2) {
                            var i = rowNum
                            while i-1 > 0 {
                                let toIndex = self.getIndex(fromPosition: (rowNum: i, columnNum: columnNum))
                                i -= 1
                                let fromIndex = self.getIndex(fromPosition: (rowNum: i, columnNum: columnNum))
                                
                                let fromCard = self.cardsBtnArray[fromIndex]
                                let toFrame = self.cardsFramesArray[toIndex]
                                fromCard?.move(toOrigin: toFrame!)
                                
                                self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                                
                                openIndex = (rowNum: i, columnNum: columnNum)
                            }
                        }
                        self.createCard(atPosition: openIndex)
                    }
                    else if(characterNeedsToMoveTo == .Above || characterNeedsToMoveTo == .Below) { // moved to a different row
                        if(columnNum == 0) {
                            for i in columnNum..<1 {
                                let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i))
                                let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i+1))
                                
                                let fromCard = self.cardsBtnArray[fromIndex]
                                let toFrame = self.cardsFramesArray[toIndex]
                                fromCard?.move(toOrigin: toFrame!)
                                
                                self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                                
                                openIndex = (rowNum: rowNum, columnNum: i+1)
                            }
                        }
                        if(columnNum == 1) {
                            let diceRoll = Int(arc4random_uniform(1))
                            let change = diceRoll == 0 ? 1 : -1
                            let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: columnNum))
                            let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: columnNum+change))
                            
                            let fromCard = self.cardsBtnArray[fromIndex]
                            let toFrame = self.cardsFramesArray[toIndex]
                            fromCard?.move(toOrigin: toFrame!)
                            
                            self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                            
                            openIndex = (rowNum: rowNum, columnNum: columnNum+change)
                        }
                        if(columnNum == 2) {
                            var i = columnNum
                            while i-1 > 0 {
                                let toIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i))
                                i -= 1
                                let fromIndex = self.getIndex(fromPosition: (rowNum: rowNum, columnNum: i))
                                
                                let fromCard = self.cardsBtnArray[fromIndex]
                                let toFrame = self.cardsFramesArray[toIndex]
                                fromCard?.move(toOrigin: toFrame!)
                                
                                self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                                
                                openIndex = (rowNum: rowNum, columnNum: i)
                            }
                        }
                        self.createCard(atPosition: openIndex)
                    }
                })
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
