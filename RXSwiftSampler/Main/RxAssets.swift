//  RxAssets.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import UIKit

enum AssetItem {
    case zero
    case one
    case two
    case three
}

struct RxProject {
    let topic: AssetItem
    let name: String
    let desc: String
    
    init(topic: AssetItem = .zero, name: String, desc: String) {
        self.topic = topic
        self.name = name
        self.desc = desc
    }
}

extension RxProject: CustomStringConvertible {
    var description: String {
        return "\(topic), \(name), \(desc)"
    }
}
