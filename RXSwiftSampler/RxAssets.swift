//  RxAssets.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

struct RxProject {
    
    let name: String
    let desc: String
    
    init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
}

extension RxProject: CustomStringConvertible {
    var description: String {
        return "\(name): \(desc)"
    }
}
