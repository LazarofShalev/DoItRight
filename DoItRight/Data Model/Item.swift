//
//  Item.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 11/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
