//
//  Item.swift
//  TodoeyApp
//
//  Created by Zizo Adel on 1/11/20.
//  Copyright © 2020 Zizo Adel. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
