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

enum CardType {
    case Character
    case Enemy
    case Potion
    case Boss
    case Armor
    case Gold
}

class ContainerView: UIView {

    var characterPosition : (rowNum : Int, columnNum : Int) = (0,0)
    
    var cardsBtnArray = [Int : CardView]()
    var cardsFramesArray = [Int : CGPoint]()
    var cardTypeArray : [CardType] = [CardType](repeating: .Character, count: 9)// TODO: Update this as well with rest of the crap
    
    var characterCard : CardView = CardView()
    
    let screenWidth = UIScreen.main.bounds.width
    
    var indexsArray = [0,1,2,3,4,5,6,7,8]
    
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
    
    func populateInitialCardTypeArray () {
        
        let potionCount = max(1,min(Int(arc4random_uniform(UInt32(3))), 2)) // should not be higher than 2, at least 1
        let armorCount = potionCount == 2 ? 1 : 2
        let enemiesCount = 4
        let maxSize = 9
        
        for i in 0..<maxSize {
            
            let randIndex = max(0,min(Int(arc4random_uniform(UInt32(maxSize - i))), maxSize - i))
            let index = indexsArray[randIndex]
            indexsArray.remove(at: randIndex)
            
            if (i == 0) {
                cardTypeArray[index] = .Character
            }
            else if(i < enemiesCount + 1) {
                cardTypeArray[index] = .Enemy
            }
            else if(i < enemiesCount + 1 + potionCount) {
                cardTypeArray[index] = .Potion
            }
            else if(i < enemiesCount + 1 + potionCount + armorCount) {
                cardTypeArray[index] = .Armor
            }
            else {
                cardTypeArray[index] = .Gold
            }
        }
    }
    
    
    func initializeGrid() {
        
        let cardDidPress: ((CardView) -> Void) = { [weak self](card) in
            self?.cardTapped(card: card)
        }
        populateTimeFrames()
        populateInitialCardTypeArray()
        
        for num in 0..<9 {
            
            var card : CardView!
            let cardType = cardTypeArray[num]
            let origin = cardsFramesArray[num]
            let size = CGSize(width: 103, height: 136)
            let rect = CGRect(origin: origin!, size: size)
            
            if(cardType == .Character) {
                card = Character(frame: rect, cardDidPress: cardDidPress)
                self.characterCard = card
            }
            else {
                card = CardView(frame: rect, cardDidPress: cardDidPress)
                if(cardType == .Enemy) {
                    card.health = -1 * max(2,min(Int(arc4random_uniform(UInt32(5))), 4)) // should not be higher than 2, at least 1
                }
                else if(cardType == .Potion) {
                    card.health = max(1,min(Int(arc4random_uniform(UInt32(3))), 2))
                }
                else if(cardType == .Gold) {
                    card.health = max(5,min(Int(arc4random_uniform(UInt32(20))), 2))
                }
                else if(cardType == .Armor) {
                    card.armor = max(1,min(Int(arc4random_uniform(UInt32(3))), 2)) // should not be higher than 2, at least 1
                }
            }
            
            card.position = getPosition(fromIndex: num)
            card.cardType = cardType
            cardsBtnArray[num] = card
            
            card.center.x -= screenWidth
            card.position = getPosition(fromIndex: num)
            self.addSubview(card)
        }
    }
    
    func createCard(atPosition cardPos : (rowNum : Int, columnNum : Int)) {
        
        let index = getIndex(fromPosition: cardPos)
        let origin = cardsFramesArray[index]
        let size = CGSize(width: 103, height: 136)
        let rect = CGRect(origin: origin!, size: size)
        cardsBtnArray[index] = CardView(frame: rect)
        cardsBtnArray[index]?.center.x -= screenWidth
        cardsBtnArray[index]?.position = cardPos
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
                    
                    var toPos : (rowNum : Int, columnNum : Int) = (0,0)
                    var fromPos : (rowNum : Int, columnNum : Int) = (0,0)
                    
                    var toIndex = 0
                    var fromIndex = 0
                    
                    if(characterNeedsToMoveTo == .Right || characterNeedsToMoveTo == .Left) { // moved to a different column
                        if(rowNum == 0) {
                            for i in rowNum..<1 {
                                
                                toPos = (rowNum: i, columnNum: columnNum)
                                fromPos = (rowNum: i+1, columnNum: columnNum)
                                
                                openIndex = (rowNum: i+1, columnNum: columnNum)
                            }
                        }
                        else if(rowNum == 1) {
                            
                            let diceRoll = Int(arc4random_uniform(1))
                            let change = diceRoll == 0 ? 1 : -1
                            
                            toPos = (rowNum: rowNum, columnNum: columnNum)
                            fromPos = (rowNum: rowNum+change, columnNum: columnNum)
                            
                            openIndex = (rowNum: rowNum+change, columnNum: columnNum)
                        }
                        else if(rowNum == 2) {
                            var i = rowNum
                            while i-1 > 0 {
                                
                                toPos = (rowNum: i, columnNum: columnNum)
                                i -= 1
                                fromPos = (rowNum: i, columnNum: columnNum)
                                
                                openIndex = (rowNum: i, columnNum: columnNum)
                            }
                        }
                        self.createCard(atPosition: openIndex)
                    }
                    else if(characterNeedsToMoveTo == .Above || characterNeedsToMoveTo == .Below) { // moved to a different row
                        if(columnNum == 0) {
                            for i in columnNum..<1 {
                                
                                toPos = (rowNum: rowNum, columnNum: i)
                                fromPos = (rowNum: rowNum, columnNum: i+1)
                                
                                openIndex = (rowNum: rowNum, columnNum: i+1)
                            }
                        }
                        if(columnNum == 1) {
                            let diceRoll = Int(arc4random_uniform(1))
                            let change = diceRoll == 0 ? 1 : -1
                            
                            toPos = (rowNum: rowNum, columnNum: columnNum)
                            fromPos = (rowNum: rowNum, columnNum: columnNum+change)
                            
                            openIndex = (rowNum: rowNum, columnNum: columnNum+change)
                        }
                        if(columnNum == 2) {
                            var i = columnNum
                            while i-1 > 0 {
                                
                                toPos = (rowNum: rowNum, columnNum: i)
                                i -= 1
                                fromPos = (rowNum: rowNum, columnNum: i)
                                
                                
                                
                                openIndex = (rowNum: rowNum, columnNum: i)
                            }
                        }
                        
                        toIndex = self.getIndex(fromPosition: toPos)
                        fromIndex = self.getIndex(fromPosition: fromPos)
                        
                        let fromCard = self.cardsBtnArray[fromIndex]
                        let toFrame = self.cardsFramesArray[toIndex]
                        fromCard?.move(toOrigin: toFrame!)
                        fromCard?.position = toPos
                        
                        self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
                        
                        self.createCard(atPosition: openIndex)
                    }
                })
            })
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
        else if(tappedCardCol - 1 == anchorCol || tappedCardCol + 1 == anchorCol) {
            canPerform = true
        }
        return canPerform
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
    
    
    func getIndex(fromPosition pos : (rowNum : Int, columnNum : Int)) -> Int {
        return pos.rowNum * 3 + pos.columnNum
    }
    
    func getPosition(fromIndex index : Int) -> (rowNum : Int, columnNum : Int) {
        let row : Int = index / 3
        let col : Int = index % 3
        return (row, col)
    }
}
