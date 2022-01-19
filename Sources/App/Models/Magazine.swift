//
//  Magazine.swift
//  
//
//  Created by Vladimir Bozhenov on 19.01.2022.
//

import Vapor
import Fluent

final class Magazine: Model, Content {
    static let schema = "magazines"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Children(for: \.$magazine)
    var issues: [Issue]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

