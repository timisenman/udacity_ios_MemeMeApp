//
//  TableViewController.swift
//  memeMe
//
//  Created by Timothy Isenman on 2/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        tableView.reloadData()
        print("\nTable View Memes\n\(self.memes!)\n")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Table View Meme Count: \(self.memes.count)")
        return self.memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\nTableView started\n")
        let reuseIdentifier = "tableView"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]
        // Configure the cell...
        cell.imageView?.image = meme.memedImage
        if cell.imageView?.image != nil {
            print("memed image set to imageView")
        }
        cell.textLabel?.text = meme.memeName
        if cell.textLabel?.text != nil {
            print("memed title set to title")
        }
        print("\nTableView ended")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsView.memes = memes[indexPath.row]
        self.navigationController?.pushViewController(detailsView, animated: true)
        
    }

    @IBAction func newMemeButtom(_ sender: Any) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(memeEditor, animated: true)
    }
    
    
}
