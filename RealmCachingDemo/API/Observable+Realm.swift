//
//  Observable+Realm.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

extension Observable where Element: Collection, Element.Element: Cacheable, Element.Element: Object {

    static func requestStartingWithCachedValues(usingCachedValues cachedValues: () -> [Element.Element], andAPIRequest apiRequest: () -> Observable<[Element.Element]>) -> Observable<[Element.Element]> {

        let cachedValues: Observable<[Element.Element]> = .just(cachedValues())
        return Observable<[Element.Element]>.merge(cachedValues, apiRequest())
    }
}

extension TimeInterval {

    static let defaultCacheTimeout: TimeInterval = 30
}

extension Observable where Element: Collection, Element.Element: Object, Element.Element: Cacheable {

    func persist(withCacheExpiry cacheExpiry: TimeInterval = Date.timeIntervalSinceReferenceDate + .defaultCacheTimeout) -> Observable<Element> {

        return self.do(onNext: { elements in
            let realm = try Current.storage.realm.create()
            try realm.write {
                for var element in elements {
                    element.cacheExpiry = cacheExpiry
                    realm.create(Element.Element.self, value: element, update: true)
                }
            }
        })
    }
}

