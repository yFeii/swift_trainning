//
//  DogeExtended.swift
//  Doge
//
//  Created by yFeii on 2020/5/25.
//  Copyright © 2020 yFeii. All rights reserved.
//

public struct DogeExtension<ExtendedType>{
    
    public private(set) var type : ExtendedType
    
    public init(_ type: ExtendedType){
        self.type = type
    }
}

public protocol DogeExtended {
 
    associatedtype ExtendedType
    //Static Doge extension
    static var dg:DogeExtension<ExtendedType>.Type { get set }
    
    //instance Doge extension
    var dg:DogeExtension<ExtendedType> { get set }
}

public extension DogeExtended {
    //Self：the class confirm to <DogeExtended> or subclass of class
    
    static var dg:DogeExtension<Self>.Type {
        get { DogeExtension<Self>.self }
        set { }
    }

    
    var dg:DogeExtension<Self> {
        get { DogeExtension(self) }
        set { }
    }

}
 
