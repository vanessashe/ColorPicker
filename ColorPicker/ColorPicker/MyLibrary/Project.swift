//
//  Project.swift
//  ReadColor
//
//  Created by 佘上翎18637 on 2019/1/23.
//  Copyright © 2019 佘上翎18637. All rights reserved.
//

import Foundation

public struct Project<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ProjectCompatible {
    /// Extended type
    associatedtype CompatibleType
    
    /// Project extensions.
    static var project: Project<CompatibleType>.Type { get set }
    
    /// Project extensions.
    var project: Project<CompatibleType> { get set }
}

extension ProjectCompatible {
    /// Project extensions.
    public static var project: Project<Self>.Type {
        get {
            return Project<Self>.self
        }
        set {
            // this enables using Project to "mutate" base type
        }
    }
    
    /// Project extensions.
    public var project: Project<Self> {
        get {
            return Project(self)
        }
        set {
            // this enables using Project to "mutate" base object
        }
    }
}


/// Extend UIColor with `Project` proxy.
//extension UIColor: ProjectCompatible { }

