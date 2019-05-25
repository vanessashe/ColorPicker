//
//  Utils.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import Foundation

public struct Utils<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol UtilsCompatible {
    /// Extended type
    associatedtype CompatibleType
    
    /// Utils extensions.
    static var utils: Utils<CompatibleType>.Type { get set }
    
    /// Utils extensions.
    var utils: Utils<CompatibleType> { get set }
}

extension UtilsCompatible {
    /// Utils extensions.
    public static var utils: Utils<Self>.Type {
        get {
            return Utils<Self>.self
        }
        set {
            // this enables using Utils to "mutate" base type
        }
    }
    
    /// Utils extensions.
    public var utils: Utils<Self> {
        get {
            return Utils(self)
        }
        set {
            // this enables using Utils to "mutate" base object
        }
    }
}


/// Extend UIColor with `Utils` proxy.
//extension UIColor: UtilsCompatible { }
