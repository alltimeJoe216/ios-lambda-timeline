//
//  PostTableViewCell.swift
//  ImagePostFilters
//
//  Created by Joe Veverka on 7/10/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageTitle: UILabel!
    
    var filteredImage: Image? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let filteredImage  = filteredImage else { return }
        imageTitle.text = "   \(filteredImage.title ?? "")"
        imageView!.image = UIImage(data: filteredImage.image!)
    }
    
}
