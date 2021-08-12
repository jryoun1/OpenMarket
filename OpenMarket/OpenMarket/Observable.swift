//
//  Observable.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/12.
//

import Foundation

final class Observable<T> {
    typealias Listener = ((T?) -> Void)
    private var listener: Listener?
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
}
