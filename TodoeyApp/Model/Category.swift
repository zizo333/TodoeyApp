//
//  Category.swift
//  TodoeyApp
//
//  Created by Zizo Adel on 1/11/20.
//  Copyright © 2020 Zizo Adel. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
