//
//  Environment.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation

struct Environment {
    var api = API()
    var storage = Storage()
}

var Current = Environment()
