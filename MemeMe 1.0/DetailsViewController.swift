//
//  DetailsViewController.swift
//  memeMe
//
//  Created by Timothy Isenman on 2/11/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var memes: Meme!
    @IBOutlet var memeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeImage.image = memes.memedImage
    }
    
}
