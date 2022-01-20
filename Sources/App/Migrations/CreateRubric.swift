//
//  CreateRubric.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Fluent

struct CreateRubric: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("rubrics")
            .id()
            .field("title", .string, .required)
            .field("issueID", .uuid, .required, .references("issues", "id"))
            .unique(on: "title")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("rubrics").delete()
    }
}

