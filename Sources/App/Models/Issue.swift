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

    @Field(key: "number")
    var number: Int
    
    @Field(key: "year")
    var year: Int
    
    @Parent(key: "magazineID")
    var magazine: Magazine

    init() {}

    init(id: UUID? = nil, number: Int, year: Int, magazineID: Magazine.IDValue) {
        self.id = id
        self.number = number
        self.year = year
        self.$magazine.id = magazineID
    }
}


