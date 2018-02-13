//
//  CollectionViewController.swift
//  memeMe
//
//  Created by Timothy Isenman on 1/30/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOutlet.delegate = self
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        collectionViewOutlet.reloadData()
        print("\nCollection View Memes:\n\(self.memes!)\n")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of memes in the [memes] array
        print("Collection View Meme count: \(self.memes.count)")
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "collectionView"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        print(meme)
        
        cell.memeImage?.image = meme.memedImage
        if cell.memeImage?.image != nil {
            print("Collection meme image set to imageView")
        }
        cell.memeName?.text = meme.memeName
        if cell.memeName?.text != nil {
            print("Collection meme title set to title")
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailView = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
//        let meme = self.memes[(indexPath as NSIndexPath).row]
//        print("\nCollection Meme selected: \(meme)\n")
//        detailView.memeImage?.image = meme.memedImage
//        if detailView.memeImage != nil {
//            print("\nCollection meme detailView image set\n")
//        }
//        self.navigationController!.pushViewController(detailView, animated: true)
//        print("Detail View Pushed from Collection View")
        
        let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsView.memes = memes[indexPath.row]
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
    
    @IBAction func newMemeButtom(_ sender: Any) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(memeEditor, animated: true)
    }


}
