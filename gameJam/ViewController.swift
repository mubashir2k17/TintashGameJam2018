//
//  ViewController.swift
//  gameJam
//
//  Created by Tintash on 05/10/2018.
//  Copyright © 2018 Tintash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var characterCollectionView: UICollectionView!
    var currentIndex: IndexPath = IndexPath(item: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        characterCollectionView.register(UINib(nibName: "CharaterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharaterCollectionViewCell")
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
        characterCollectionView.isScrollEnabled = false
    }

    @IBAction func rightButtonPress(_ sender: Any) {
        characterCollectionView.scrollToItem(at: IndexPath(item: currentIndex.row + 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }

    @IBAction func leftButtonPress(_ sender: Any) {
        characterCollectionView.scrollToItem(at: IndexPath(item: currentIndex.row - 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    @IBAction func playButton(_ sender: Any) {
        let combatViewController = CombatViewController(nibName: "CombatViewController", bundle: nil)
        combatViewController.player = "player"
        self.present(combatViewController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharaterCollectionViewCell", for: indexPath) as? CharaterCollectionViewCell {
            cell.indexPath = indexPath
            return cell
        }
        return CharaterCollectionViewCell()
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

