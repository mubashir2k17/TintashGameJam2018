//
//  CombatViewController.swift
//  gameJam
//
//  Created by AbdurRafay on 06/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit
import GTProgressBar
import SwiftySound

class CombatViewController: UIViewController {
    var player: String?
    @IBOutlet weak var gridContainerView: ContainerView!
    @IBOutlet weak var mutationProgressBar: GTProgressBar!
    @IBOutlet weak var goldLbl: UILabel!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gridContainerView.initializeGrid(player: player!)
        // Do any additional setup after loading the view.
        mutationProgressBar.animateTo(progress: 0.05, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            Sound.play(file: "jack_in_the_box-Mike_Koenig", fileExtension: "mp3", numberOfLoops: 3000)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gridContainerView.loadGridWithAnimation(index: 0)
        gridContainerView.mutationDidChange = { [weak self] percentage in
            let perc = min(percentage, 1.0)
            self?.mutationProgressBar.animateTo(progress: perc)
        }
        gridContainerView.dismissVC = {[weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        gridContainerView.showAlert = { [weak self] (alert) in
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
        }
        gridContainerView.goldValueUpdated = {[weak self] in
            DispatchQueue.main.async {
                self?.goldLbl.text = "\(self?.gridContainerView.goldValue ?? 0)"
            }
        }
    }

    @IBAction func homeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
