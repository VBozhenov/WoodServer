//
//  CreateMagazine.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Fluent

struct CreateMagazine: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("magazines")
            .id()
            .field("title", .string)
            .unique(on: "title")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("magazines").delete()
    }
}

