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
        
        
//        categoriesRoute.get(":categoryID", use: getCategoryHandler)
//        categoriesRoute.delete(":categoryID", use: deleteHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Magazine]> {
        return Magazine
            .query(on: req.db)
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

//    func getCategoryHandler(_ req: Request) throws -> EventLoopFuture<Category> {
//        guard let parameters = req.parameters.get("categoryID"),
//              let uuid = UUID(uuidString: parameters) else { fatalError() }
//        return Category
//            .query(on: req.db)
//            .filter ( \.$id == uuid )
//            .with(\.$childrenCategories)
//            .with(\.$items)
//            .first()
//            .unwrap(or: Abort(.notFound))
//    }
//
//    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        Category.find(req.parameters.get("categoryID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { category in
//                category.delete(on: req.db)
//                    .transform(to: .noContent)
//            }
//    }
}

//struct CreateMagazineData: Content {
//    let title: String
//}
