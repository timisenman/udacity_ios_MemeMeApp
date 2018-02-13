//
//  DetailsViewController.swift
//  memeMe
//
//  Created by Timothy Isenman on 2/11/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var memeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        memes = appDelegate.memes
        
//        self.memeImage.image = memes.memedImage
    }
    
}
