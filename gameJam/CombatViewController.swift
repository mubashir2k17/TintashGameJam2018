//
//  CombatViewController.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit
import GTProgressBar

class CombatViewController: UIViewController {
    var player: String?
    @IBOutlet weak var gridContainerView: ContainerView!
    @IBOutlet weak var mutationProgressBar: GTProgressBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        gridContainerView.initializeGrid()
        // Do any additional setup after loading the view.
        mutationProgressBar.animateTo(progress: 0.10, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gridContainerView.loadGridWithAnimation(index: 0)
        gridContainerView.mutationDidChange = { [weak self] percentage in
            self?.mutationProgressBar.animateTo(progress: 0.5)
        }
    }

    @IBAction func homeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
