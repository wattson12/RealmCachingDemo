//
//  Cacheable.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation

protocol Cacheable: Decodable {
    associatedtype ViewStateType
    var cacheExpiry: TimeInterval { get set }
    var viewState: ViewStateType { get }
}

extension Array: Cacheable where Element: Cacheable {
    typealias ViewStateType = [Element.ViewStateType]

    var viewState: [Element.ViewStateType] {
        return map { $0.viewState }
    }

    var cacheExpiry: TimeInterval {
        get { return 0 }
        set { }
    }
}
