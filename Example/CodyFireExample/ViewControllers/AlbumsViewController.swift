//
//  AlbumsViewController.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class AlbumsViewController: UITableViewController {
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.album.get().onError { error in
            let alert = UIAlertController(title: "Known error handled", message: error.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            }.onSuccess { albums in
                self.albums = albums
                self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Album")!
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.title
        return cell
    }
}
