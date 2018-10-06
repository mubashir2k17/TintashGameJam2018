//
//  ContainerView.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class ContainerView: UIView {

    var anchorPosition : (rowNum : Int, columnNum : Int) = (0,0)
    var cardsBtnArray = [Int : CardView]()
    
    func canPerformAction(onCardPosition cardPos : (rowNum : Int, columnNum : Int)) -> Bool {
        
        var canPerform = false
        let anchorRow = anchorPosition.rowNum
        let anchorCol = anchorPosition.columnNum
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
    
    func getIndex(fromPosition pos :(rowNum : Int, columnNum : Int)) -> Int {
        return pos.rowNum * 3 + pos.columnNum
    }
    
    func initializeGrid() {
        cardsBtnArray[0] = CardView(frame: CGRect(x: 0, y: 0, width: 103, height: 136))
        cardsBtnArray[1] = CardView(frame: CGRect(x: 103, y: 0, width: 103, height: 136))
        cardsBtnArray[2] = CardView(frame: CGRect(x: 206, y: 0, width: 103, height: 136))
        cardsBtnArray[3] = CardView(frame: CGRect(x: 0, y: 136, width: 103, height: 136))
        cardsBtnArray[4] = CardView(frame: CGRect(x: 103, y: 136, width: 103, height: 136))
        cardsBtnArray[5] = CardView(frame: CGRect(x: 206, y: 136, width: 103, height: 136))
        cardsBtnArray[6] = CardView(frame: CGRect(x: 0, y: 272, width: 103, height: 136))
        cardsBtnArray[7] = CardView(frame: CGRect(x: 103, y: 272, width: 103, height: 136))
        cardsBtnArray[8] = CardView(frame: CGRect(x: 206, y: 272, width: 103, height: 136))
    }
}
