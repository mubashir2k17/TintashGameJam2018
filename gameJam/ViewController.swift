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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        characterCollectionView.register(UINib(nibName: "CharaterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharaterCollectionViewCell")
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharaterCollectionViewCell", for: indexPath) as? CharaterCollectionViewCell {
            return cell
        }
        return CharaterCollectionViewCell()
    }


}

