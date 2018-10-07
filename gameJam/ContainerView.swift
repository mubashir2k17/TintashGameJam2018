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
    case BlindMutation
}

class ContainerView: UIView {

    //TODO: Add better backgrounds to the numbers on card top left and right, need to increase their size as well as they are quiet hard to read
    var cardsBtnArray = [Int : CardView]()
    var cardsFramesArray = [Int : CGPoint]()
    var cardTypeArray : [CardType] = [CardType](repeating: .Character, count: 9)// TODO: Update this as well with rest of the crap
    
    var characterCard : CardView = CardView()
    
    let screenWidth = UIScreen.main.bounds.width
    
    var indexsArray = [0,1,2,3,4,5,6,7,8]
    
    let startingEnemiesCount = 4
    var currentEnemiesCount = 4
    var minEnemyCount = 3
    
    var blindMutationCount = 0
    var maxBlindMutationCount = 1
    var movesRequiredToUndoBlind = 4 // essentially will be 3 since the first step is counted when we get the blindness
    var movesDoneForBlind = 0
    
    var goldValue = 0
    var mutationValue = 0 {
        didSet {
            mutationDidChange?(CGFloat(mutationValue/maxMutationValue))
        }
    }
    var maxMutationValue = 100 // TODO: Fill a progress bar above basied on mutationValue and maxMutationValue
    
    var isHidingCards = false

    var mutationDidChange: ((CGFloat)->())? = nil
    
    var cardCreationCounter = 0
    
    // asset names to Load
    let character = [(assetName: "knightIdle", startIndex: 0, endIndex: 6),
                          (assetName: "robotIdle", startIndex: 0, endIndex: 8),
                          (assetName: "robotGoldenIdle", startIndex: 0, endIndex: 8),
                          (assetName: "trolIdle", startIndex: 0, endIndex: 6),
                          (assetName: "trollGreenIdle", startIndex: 0, endIndex: 9),
                          (assetName: "womanWarrior", startIndex: 0, endIndex: 4),
                          (assetName: "zombieIdle", startIndex: 1, endIndex: 15),
                          (assetName: "zombieFiemaleIdle", startIndex: 1, endIndex: 15),
                          (assetName: "zombieHurt", startIndex: 1, endIndex: 5)]
    
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
        
        let maxSize = 9
        
        for i in 0..<maxSize {
            
            if (i == 0) {
                let randIndex = max(0,min(Int(arc4random_uniform(UInt32(maxSize - i))), maxSize - i))
                let index = indexsArray[randIndex]
                indexsArray.remove(at: randIndex)
                
                cardTypeArray[index] = .Character
            }
            else {
                let randIndex = max(0,min(Int(arc4random_uniform(UInt32(maxSize - i))), maxSize - i))
                let index = indexsArray[randIndex]
                indexsArray.remove(at: randIndex)
                
                if(i < startingEnemiesCount + 1) {
                    cardTypeArray[index] = .Enemy
                }
                else if(i < startingEnemiesCount + 1 + potionCount) {
                    cardTypeArray[index] = .Potion
                }
                else if(i < startingEnemiesCount + 1 + potionCount + armorCount) {
                    cardTypeArray[index] = .Armor
                }
                else {
                    cardTypeArray[index] = .Gold
                }
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
                card.setupCard(params: character[0])
            }
            else {
                card = CardView(frame: rect, cardDidPress: cardDidPress)
                setupCard(card: card, cardType: cardType)
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
        
        let cardDidPress: ((CardView) -> Void) = { [weak self](card) in
            self?.cardTapped(card: card)
        }
        
        let card = CardView(frame: rect, cardDidPress: cardDidPress)
        cardsBtnArray[index] = card
        
        var isXModifier = true
        var modifier : CGFloat = 0
        if (cardPos.columnNum == 0) {
            modifier = -1 * screenWidth
        }
        else if(cardPos.columnNum == 2) {
            modifier = screenWidth
        }
        else if(cardPos.rowNum == 0 && cardPos.columnNum == 1) {
            modifier = -1 * screenWidth
            isXModifier = false
        }
        else if(cardPos.rowNum == 2 && cardPos.columnNum == 1) {
            modifier = screenWidth
            isXModifier = false
        }
        if(isXModifier) {
            card.center.x += modifier
        }
        else {
            card.center.y += modifier
        }
        card.position = cardPos
        
        var cardType : CardType!
        if(cardCreationCounter == 0) {
            cardType = .Enemy
        }
        else if(cardCreationCounter == 1) {
            cardType = .BlindMutation
        }
        else if(cardCreationCounter == 2) {
            cardType = .Potion
        }
        else if(cardCreationCounter == 3) {
            cardType = .Armor
        }
        else if(cardCreationCounter == 4) {
            cardType = .Gold
        }
        
        cardCreationCounter = (cardCreationCounter + 1) % 5
        
        /*
        if(currentEnemiesCount < minEnemyCount) {
            cardType = .Enemy
        }
        else {
            let randomNumberType = min(Int(arc4random_uniform(UInt32(3))), 2)
            if(randomNumberType == 0) {
                cardType = .Potion
            }
            else if(randomNumberType == 1) {
                cardType = .Gold
            }
            else if(randomNumberType == 2) {
                cardType = .Armor
            }
        }
 */
        setupCard(card: card, cardType: cardType)
        
        card.cardType = cardType
        if(isHidingCards) {
            card.hideCard()
        }
        self.addSubview(card)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.curveEaseOut],
                       animations: {
                        if(isXModifier) {
                            card.center.x += -1 * modifier
                        }
                        else {
                            card.center.y += -1 * modifier
                        }
        },completion: nil)
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
            let cardFrame = card.frame.origin
            let tappedCardPosition = card.position
            let tappedCardIndex = getIndex(fromPosition: tappedCardPosition)
            if(isHidingCards) {
                card.showCard()
            }
            card.die(withCompletion: { () in
                
                self.updateCounts(expiredCard: card)
                
                let character = self.characterCard
                let characterNeedsToMoveTo = self.getCardPositionRelativeToCharacter(cardPos: card.position)
                character.move(toOrigin: cardFrame, completion: { () in
                    
                    let columnNum = character.position.columnNum
                    let rowNum = character.position.rowNum
                    var openIndex : (rowNum : Int, columnNum : Int) = (0,0)
                    
                    var toPos : (rowNum : Int, columnNum : Int) = (0,0)
                    var fromPos : (rowNum : Int, columnNum : Int) = (0,0)
                    
                    if(characterNeedsToMoveTo == .Right || characterNeedsToMoveTo == .Left) { // moved to a different column
                        if(rowNum == 0) {
                            for i in rowNum..<2 {
                                
                                toPos = (rowNum: i, columnNum: columnNum)
                                fromPos = (rowNum: i+1, columnNum: columnNum)
                                
                                openIndex = (rowNum: i+1, columnNum: columnNum)
                                self.doStuff(toPos: toPos, fromPos: fromPos)
                            }
                        }
                        else if(rowNum == 1) {
                            
                            let diceRoll = Int(arc4random_uniform(2))
                            let change = diceRoll == 0 ? 1 : -1
                            
                            toPos = (rowNum: rowNum, columnNum: columnNum)
                            fromPos = (rowNum: rowNum+change, columnNum: columnNum)
                            
                            openIndex = (rowNum: rowNum+change, columnNum: columnNum)
                            self.doStuff(toPos: toPos, fromPos: fromPos)
                        }
                        else if(rowNum == 2) {
                            var i = rowNum
                            while i-1 >= 0 {
                                
                                toPos = (rowNum: i, columnNum: columnNum)
                                i -= 1
                                fromPos = (rowNum: i, columnNum: columnNum)
                                
                                openIndex = (rowNum: i, columnNum: columnNum)
                                self.doStuff(toPos: toPos, fromPos: fromPos)
                            }
                        }
                    }
                    else if(characterNeedsToMoveTo == .Above || characterNeedsToMoveTo == .Below) { // moved to a different row
                        if(columnNum == 0) {
                            for i in columnNum..<2 {
                                
                                toPos = (rowNum: rowNum, columnNum: i)
                                fromPos = (rowNum: rowNum, columnNum: i+1)
                                
                                openIndex = (rowNum: rowNum, columnNum: i+1)
                                self.doStuff(toPos: toPos, fromPos: fromPos)
                            }
                        }
                        if(columnNum == 1) {
                            let diceRoll = Int(arc4random_uniform(2))
                            let change = diceRoll == 0 ? 1 : -1
                            
                            toPos = (rowNum: rowNum, columnNum: columnNum)
                            fromPos = (rowNum: rowNum, columnNum: columnNum+change)
                            
                            openIndex = (rowNum: rowNum, columnNum: columnNum+change)
                            self.doStuff(toPos: toPos, fromPos: fromPos)
                        }
                        if(columnNum == 2) {
                            var i = columnNum
                            while i-1 >= 0 {
                                
                                toPos = (rowNum: rowNum, columnNum: i)
                                i -= 1
                                fromPos = (rowNum: rowNum, columnNum: i)
                                
                                openIndex = (rowNum: rowNum, columnNum: i)
                                self.doStuff(toPos: toPos, fromPos: fromPos)
                            }
                        }
                    }
                    self.createCard(atPosition: openIndex)
                    self.cardsBtnArray[tappedCardIndex] = self.characterCard
                    self.characterCard.position = tappedCardPosition
                })
            })
        }
    }
    
    func doStuff(toPos : (rowNum : Int, columnNum : Int), fromPos : (rowNum : Int, columnNum : Int)) { // Moves cards around the screen, in the grid array, updates the frames as well
        
        let toIndex = self.getIndex(fromPosition: toPos)
        let fromIndex = self.getIndex(fromPosition: fromPos)
        
        let fromCard = self.cardsBtnArray[fromIndex]
        let toFrame = self.cardsFramesArray[toIndex]
        fromCard?.move(toOrigin: toFrame!)
        fromCard?.position = toPos
        
        self.cardsBtnArray[toIndex] = self.cardsBtnArray[fromIndex]
    }
    
    func canPerformAction(onCardPosition cardPos : (rowNum : Int, columnNum : Int)) -> Bool {
        
        var canPerform = false
        let anchorRow = characterCard.position.rowNum
        let anchorCol = characterCard.position.columnNum
        let tappedCardRow = cardPos.rowNum
        let tappedCardCol = cardPos.columnNum
        if((tappedCardRow - 1 == anchorRow || tappedCardRow + 1 == anchorRow) && tappedCardCol == anchorCol) {
            canPerform = true
        }
        else if((tappedCardCol - 1 == anchorCol || tappedCardCol + 1 == anchorCol) && tappedCardRow == anchorRow) {
            canPerform = true
        }
        return canPerform
    }
    
    func getCardPositionRelativeToCharacter(cardPos : (rowNum : Int, columnNum : Int)) -> RelativePositionToCharacter {
        
        var posEnum = RelativePositionToCharacter.None
        let anchorRow = characterCard.position.rowNum
        let anchorCol = characterCard.position.columnNum
        
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
    
    func updateCounts(expiredCard: CardView) {
        
        if(expiredCard.cardType == .Enemy || expiredCard.cardType == .Gold) {
            goldValue += expiredCard.health
            if(expiredCard.cardType == .Enemy) {
                currentEnemiesCount -= 1
                if let character = characterCard as? Character {
                    character.addHealth(healthValue: expiredCard.health)
                }
            }
            mutationValue += 2 * abs(expiredCard.health)
        }
        else if(expiredCard.cardType == .Potion) {
            if let character = characterCard as? Character {
                character.addHealth(healthValue: expiredCard.health)
            }
            mutationValue += -1 * expiredCard.health
        }
        else if(expiredCard.cardType == .Armor) {
            if let character = characterCard as? Character {
                character.addArmor(armorValue: expiredCard.armor)
            }
        }
        else if(expiredCard.cardType == .BlindMutation) {
            if(!isHidingCards) {
                hideAllCards()
            }
        }
        
        if(isHidingCards) {
            movesDoneForBlind += 1
            if(movesDoneForBlind == movesRequiredToUndoBlind) {
                showAllCards()
            }
        }
        
        if(self.characterCard.health == 0) {
            //TODO: Game over stuff
        }
    }
    
    func setupCard(card : CardView, cardType : CardType) {
        
        if(cardType == .Enemy) {
            card.health = -1 * max(2,min(Int(arc4random_uniform(UInt32(5))), 4)) // should not be higher than 2, at least 1
            card.setupCard(params: character[2])
        }
        else if(cardType == .Potion) {
            card.health = max(1,min(Int(arc4random_uniform(UInt32(3))), 2))
            card.setupCard(params: character[3]) // TODO: Change images for potion
        }
        else if(cardType == .Gold) {
            card.health = max(5,min(Int(arc4random_uniform(UInt32(20))), 2))
            card.setupCard(params: character[4]) // TODO: Change images for Gold
        }
        else if(cardType == .Armor) {
            card.armor = max(1,min(Int(arc4random_uniform(UInt32(3))), 2)) // should not be higher than 2, at least 1
            card.setupCard(params: character[5]) // TODO: Change images for Armor
        }
        else if(cardType == .BlindMutation) {
            card.setupCard(params: character[5]) // TODO: Change images for Blind Mutation
            mutationValue += 5
        }
        card.backgroundImageView.image = #imageLiteral(resourceName: "tile2")
        card.backgroundImageView.layer.cornerRadius = 12
        card.backgroundImageView.layer.addGradienBorder(colors: [UIColor.red, UIColor.yellow, UIColor.green], width: 8.0, radius: 12)
    }
    
    func getIndex(fromPosition pos : (rowNum : Int, columnNum : Int)) -> Int {
        return pos.rowNum * 3 + pos.columnNum
    }
    
    func getPosition(fromIndex index : Int) -> (rowNum : Int, columnNum : Int) {
        let row : Int = index / 3
        let col : Int = index % 3
        return (row, col)
    }
    
    func hideAllCards() {
        isHidingCards = true
        movesDoneForBlind = 0
        for i in 0..<9 {
            let card = cardsBtnArray[i]
            if(card != characterCard) {
                card?.hideCard()
            }
        }
    }
    
    func showAllCards() {
        isHidingCards = false
        movesDoneForBlind = 0
        for i in 0..<9 {
            let card = cardsBtnArray[i]
            if(card != characterCard) {
                card?.showCard()
            }
        }
    }
}
