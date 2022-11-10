//
//  File.swift
//  KnowFace
//
//  Created by Naeem Hussain on 24/10/2022.
//

import Foundation

struct PopupFields
{
    var name : String
    var detail : String
}

final class Observable<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    //Box has a generic type value.. The didSet property observer detects any changes and notifies Listener of any value update..
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    //The initializer sets Box‘s initial value...
    init(_ value: T) {
        self.value = value
    }
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}


enum InputDataValues : String {
    case cardFrontOrginal = "card_front_orgnal_image"
    case cardFrontScaned = "card_front_scaned_image"
    case cardBackOrginal = "card_back_orgnal_image"
    case cardBackScaned = "card_back_scaned_image"
}
