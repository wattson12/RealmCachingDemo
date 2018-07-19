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

extension Realm: ReactiveCompatible { }

extension Reactive where Base == Realm {

    func cachedValues<Model: Cacheable>(forModel modelType: Model.Type, currentTime: TimeInterval = Date.timeIntervalSinceReferenceDate) -> Observable<[Model]> where Model: Object {
        return Observable.create { observer in

            let cachedObjects = self.base.objects(Model.self).filter { element in
                return element.cacheExpiry > currentTime
            }

            observer.onNext(Array(cachedObjects))

            return Disposables.create()
        }
    }
}

extension Observable where Element: Collection, Element.Element: Cacheable, Element.Element: Object {

    static func requestStartingWithCachedValues(usingAPIRequest apiRequest: () -> Observable<[Element.Element]>) -> Observable<[Element.Element]> {

        let cachedValues: Observable<[Element.Element]>
        if let realm = try? Current.storage.realm.create() {
            cachedValues = realm.rx.cachedValues(forModel: Element.Element.self)
        } else {
            cachedValues = .just([])
        }

        return Observable<[Element.Element]>.merge(cachedValues, apiRequest())
    }
}

extension Observable where Element: Collection, Element.Element: Object, Element.Element: Cacheable {

    func persist(withCacheExpiry cacheExpiry: TimeInterval = Date.timeIntervalSinceReferenceDate + 30) -> Observable<Element> {

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

