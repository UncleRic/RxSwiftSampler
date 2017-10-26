//  RxAssets.swift
//  RXSwiftSampler
//
//  Created by Frederick C. Lee on 10/17/17.
//  Copyright © 2017 Amourine Technologies. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import UIKit

enum Chapter {
    case zero
    case one
    case two
    case three
}

struct RxProject {
    let topic: Chapter
    let name: String
    let chapter: String
    
    init(topic: Chapter = .zero, name: String, chapter: String) {
        self.topic = topic
        self.name = name
        self.chapter = chapter
    }
}

extension RxProject: CustomStringConvertible {
    var description: String {
        return "\(topic), \(name), \(chapter)"
    }
}
