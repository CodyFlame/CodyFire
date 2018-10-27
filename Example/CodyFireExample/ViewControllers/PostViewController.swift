//
//  PostViewController.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.isHidden = true
        self.descriptionLabel.isHidden = true
        API.post.get(by: id).onRequestStarted {
            self.activityIndicator.startAnimating()
        }.onKnownError { error in
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Known error handled", message: error.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }.onSuccess { post in
            self.activityIndicator.stopAnimating()
            self.titleLabel.isHidden = false
            self.descriptionLabel.isHidden = false
            self.titleLabel.text = post.title
            self.descriptionLabel.text = post.body
        }
    }
}
