//
//  CreateArticle.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Fluent

struct CreateArticle: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles")
            .id()
            .field("title", .string, .required)
            .field("page", .int, .required)
            .field("description", .string)
            .field("issueID", .uuid, .required, .references("issues", "id"))
//            .field("rubricID", .uuid, .references("rubrics", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("articles").delete()
    }
}

