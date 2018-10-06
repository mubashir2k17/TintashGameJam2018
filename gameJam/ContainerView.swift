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
    var cardsBtnArray = [CardView]()
    
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
}
