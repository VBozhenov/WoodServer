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
            .field("title", .string)
            .field("year", .int)
            .field("magazineID", .uuid, .required, .references("magazines", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("issues").delete()
    }
}
