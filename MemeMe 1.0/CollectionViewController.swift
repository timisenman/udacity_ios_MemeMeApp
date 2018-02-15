//
//  CollectionViewController.swift
//  memeMe
//
//  Created by Timothy Isenman on 1/30/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOutlet.delegate = self
        memes = appDelegate.memes
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        collectionViewOutlet.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "collectionViewReuseIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImage?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsView.memes = memes[indexPath.row]
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
    
    @IBAction func newMemeButtom(_ sender: Any) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(memeEditor, animated: true, completion: nil)
    }
    
    
}
