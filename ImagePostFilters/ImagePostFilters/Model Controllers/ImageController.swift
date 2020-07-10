//
//  ImageController.swift
//  ImagePostFilters
//
//  Created by Joe Veverka on 7/9/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit
import CoreData

class ImageController {
    
    var imagePosts: [Image] = []
    
    @discardableResult
    func appendImage(images: Data, title: String, latitude: Double, longitude: Double) -> Image {
        
        let imagePost = Image(image: images, title: title, latitude: latitude, longitide: longitude, date: Date())
        imagePosts.append(imagePost)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            fatalError("Could not save image post: \(error)")
        }
        return imagePost
        
    }
}
