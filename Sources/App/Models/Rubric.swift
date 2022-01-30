//
//  Rubric.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Vapor
import Fluent

final class Rubric: Model, Content {
    static let schema = "rubrics"

    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
//    @Children(for: \.$rubric)
//    var articles: [Article]

    init() {}

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
