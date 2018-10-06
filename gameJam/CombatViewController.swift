//
//  CombatViewController.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class CombatViewController: UIViewController {
    var player: String?
    @IBOutlet weak var gridContainerView: ContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridContainerView.initializeGrid()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gridContainerView.loadGridWithAnimation(index: 0)
    }
}
