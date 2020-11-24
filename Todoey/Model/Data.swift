//
//  Data.swift
//  Todoey
//
//  Created by Simon Mostrøm Nielsen on 24/11/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
