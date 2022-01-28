//
//  RubricsController.swift
//  
//
//  Created by Vladimir Bozhenov on 28.01.2022.
//

import Vapor
import Fluent

struct RubricsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rubricsRoute = routes.grouped("api", "rubrics")
        
        rubricsRoute.get("all", use: getAllHandler)
        rubricsRoute.post(use: createHandler)
        rubricsRoute.put(":rubricID", use: updateHandler)
        rubricsRoute.delete(":rubricID", use: deleteHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Rubric]> {
        return Rubric
            .query(on: req.db)
            .sort(\.$title, .ascending)
            .with(\.$articles)
            .all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Rubric> {
        let rubric = try req.content.decode(Rubric.self)
        return rubric.save(on: req.db).map { rubric }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Rubric> {
        let updateData = try req.content.decode(Rubric.self)
        return Rubric
            .find(req.parameters.get("rubricID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { rubric in
                rubric.title = updateData.title
                return rubric.save(on: req.db).map { rubric }
            }
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Rubric.find(req.parameters.get("rubricID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { rubric in
                rubric.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}

