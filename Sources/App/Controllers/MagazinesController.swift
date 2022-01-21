//
//  MagazinesController.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Vapor
import Fluent

struct MagazinesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let magazinesRoute = routes.grouped("api", "magazines")
        
        magazinesRoute.get("all", use: getAllHandler)
        magazinesRoute.post(use: createHandler)
        magazinesRoute.put(":magazineID", use: updateHandler)
        magazinesRoute.delete(":magazineID", use: deleteHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Magazine]> {
        return Magazine
            .query(on: req.db)
            .sort(\.$title, .ascending)
            .with(\.$issues)
            .all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Magazine> {
        let magazine = try req.content.decode(Magazine.self)
        return magazine.save(on: req.db).map { magazine }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Magazine> {
        let updateData = try req.content.decode(Magazine.self)
        return Magazine
            .find(req.parameters.get("magazineID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { magazine in
                magazine.title = updateData.title
                return magazine.save(on: req.db).map { magazine }
            }
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Magazine.find(req.parameters.get("magazineID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { magazine in
                magazine.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
