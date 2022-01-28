//
//  CreateIssue.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Fluent

struct CreateIssue: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("issues")
            .id()
            .field("title", .string, .required)
            .field("year", .int, .required)
            .field("magazineID", .uuid, .required, .references("magazines", "id"))
            .unique(on: "title", "year")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("issues").delete()
    }
}
