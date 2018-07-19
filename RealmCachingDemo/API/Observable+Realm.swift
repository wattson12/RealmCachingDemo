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

    static func requestStartingWithCachedValues(usingCachedValues cachedValues: @escaping () -> [Element.Element], andAPIRequest apiRequest: () -> Observable<[Element.Element]>) -> Observable<[Element.Element]> {

        let cachedValuesObservable: Observable<[Element.Element]> = .just(cachedValues())
        let apiRequestWithCacheUpdated: Observable<[Element.Element]> = apiRequest().updateCache(cachedValues: cachedValues)
        return Observable<[Element.Element]>.merge(cachedValuesObservable, apiRequestWithCacheUpdated)
    }
}

extension TimeInterval {

    static let defaultCacheTimeout: TimeInterval = 300
}

extension Observable where Element: Collection, Element.Element: Object, Element.Element: Cacheable {

    func updateCache(withCacheExpiry cacheExpiry: TimeInterval = Current.currentTime() + .defaultCacheTimeout, cachedValues: @escaping () -> [Element.Element]) -> Observable<Element> {

        return self.do(onNext: { elements in
            let realm = try Current.storage.realm.create()
            try realm.write {
                var currentCachedValues = cachedValues()

                for var element in elements {
                    element.cacheExpiry = cacheExpiry
                    realm.create(Element.Element.self, value: element, update: true)

                    print(currentCachedValues)
                    currentCachedValues.forEach { print($0, $0.isSameObject(as: element)) }

                    if let indexOfCurrentElement = currentCachedValues.index(where: { $0.isSameObject(as: element)} ) {
                        currentCachedValues.remove(at: indexOfCurrentElement)
                    }
                }

                for cachedValueNotInResponse in currentCachedValues {
                    print("removing from cache: \(cachedValueNotInResponse)")
                    realm.delete(cachedValueNotInResponse)
                }
            }
        })
    }
}

