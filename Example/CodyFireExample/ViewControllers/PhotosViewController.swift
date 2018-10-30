//
//  PhotosViewController.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController: UITableViewController {
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.photo.get().onError { error in
            let alert = UIAlertController(title: "Known error handled", message: error.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            }.onSuccess { photos in
                self.photos = photos
                self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo")!
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.title
        cell.detailTextLabel?.text = photo.thumbnailUrl
        return cell
    }
}
