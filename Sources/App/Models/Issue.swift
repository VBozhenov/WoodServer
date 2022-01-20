//
//  Issue.swift
//  
//
//  Created by Vladimir Bozhenov on 19.01.2022.
//

import Vapor
import Fluent

final class Issue: Model, Content {
    static let schema = "issues"

    @ID
    var id: UUID?

    @OptionalField(key: "number")
    var number: Int?
    
    @OptionalField(key: "title")
    var title: String?
    
    @Field(key: "year")
    var year: Int
    
    @Parent(key: "magazineID")
    var magazine: Magazine
    
    @Children(for: \.$issue)
    var rubrics: [Rubric]

    init() {}

    init(id: UUID? = nil, number: Int? = nil, title: String? = nil, year: Int, magazineID: Magazine.IDValue) {
        self.id = id
        self.number = number
        self.title = title
        self.year = year
        self.$magazine.id = magazineID
    }
}


