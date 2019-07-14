//
//  Category.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 11/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
