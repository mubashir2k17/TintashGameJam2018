//
//  ViewController.swift
//  gameJam
//
//  Created by Tintash on 05/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit
import SwiftySound

class ViewController: UIViewController {

    var mainIndex = 0
    var inverse = 0
    var player: String!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var goldLbl: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var currentIndex: IndexPath = IndexPath(item: 0, section: 0)
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        characterCollectionView.register(UINib(nibName: "CharaterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharaterCollectionViewCell")
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
        characterCollectionView.isScrollEnabled = false
        leftButton.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        let gold = defaults.integer(forKey: "gold")
        goldLbl.text = "\(gold)"
    }

    @IBAction func rightButtonPress(_ sender: Any) {
        if mainIndex < 1 {
            leftButton.isEnabled = true
            rightButton.isEnabled = true
            mainIndex += 1
            characterCollectionView.scrollToItem(at: IndexPath(item: currentIndex.row + 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            if mainIndex == 1 {
                rightButton.isEnabled = false
            }
        }
        else {
            rightButton.isEnabled = false
        }
    }

    @IBAction func leftButtonPress(_ sender: Any) {
        if mainIndex > 0
        {
            leftButton.isEnabled = true
            rightButton.isEnabled = true
            mainIndex -= 1
            characterCollectionView.scrollToItem(at: IndexPath(item: currentIndex.row - 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            if mainIndex == 0 {
                leftButton.isEnabled = false
            }
        }
        else {
            leftButton.isEnabled = false
        }
        
    }
    @IBAction func playButton(_ sender: Any) {
        let combatViewController = CombatViewController(nibName: "CombatViewController", bundle: nil)
        if mainIndex == 0 {
            player = "WomenWarrior"
        }
        else if mainIndex == 1{
            player = "Knight"
        }
        combatViewController.player = player
        Sound.play(file: "soundplaybutton.mp3")
        self.present(combatViewController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharaterCollectionViewCell", for: indexPath) as? CharaterCollectionViewCell {
            cell.indexPath = indexPath
            if inverse == 0 {
                cell.setPlayer1()
                inverse = 1
            }
            else {
                cell.setPlayer2()
                inverse = 0
            }
            
            return cell
        }
        return CharaterCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width - 90.0, height: 459.0)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = characterCollectionView.visibleCells[0] as? CharaterCollectionViewCell {
            currentIndex = cell.indexPath
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let cell = characterCollectionView.visibleCells[0] as? CharaterCollectionViewCell {
            currentIndex = cell.indexPath
        }
    }




}

