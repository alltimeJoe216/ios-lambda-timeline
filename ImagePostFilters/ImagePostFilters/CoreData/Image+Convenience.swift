//
//  Image+Convenience.swift
//  ImagePostFilters
//
//  Created by Joe Veverka on 7/9/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import Foundation
import CoreData

extension Image {
    @discardableResult
    convenience init(image: Data,
                     title: String,
                     latitude: Double,
                     longitide: Double,
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.image = image
        self.date = date
        self.title = title
        self.latitude = latitude
        self.longitude = longitide
    }
}
