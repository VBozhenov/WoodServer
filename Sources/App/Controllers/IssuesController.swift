//
//  IssuesController.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Vapor
import Fluent
import Foundation

struct IssuesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let issuesRoute = routes.grouped("api", "issues")
        
        issuesRoute.get("all", use: getAllHandler)
        issuesRoute.get(":magazineID", use: getMagazineIssuesHandler)
        issuesRoute.post(use: createHandler)
        issuesRoute.put(":issueID", use: updateHandler)
        issuesRoute.delete(":issueID", use: deleteHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Issue]> {
        return Issue
            .query(on: req.db)
            .sort(\.$title, .ascending)
            .with(\.$articles)
            .all()
    }
    
    func getMagazineIssuesHandler(_ req: Request) throws -> EventLoopFuture<[Issue]> {
        let stringMagazineID = req.parameters.get("magazineID") ?? ""
        let magazineID = UUID(uuidString: stringMagazineID) ?? UUID()
        return Issue
            .query(on: req.db)
            .filter(\.$magazine.$id == magazineID)
            .sort(\.$title, .ascending)
            .with(\.$articles)
            .all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Issue> {
        let data = try req.content.decode(CreateIssueData.self)
        let issue = Issue(title: data.title, year: data.year, magazineID: data.magazineID)
        return issue.save(on: req.db).map { issue }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Issue> {
        let updateData = try req.content.decode(CreateIssueData.self)
        return Issue
            .find(req.parameters.get("issueID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { issue in
                issue.title = updateData.title
                issue.year = updateData.year
                issue.$magazine.id = updateData.magazineID
                return issue.save(on: req.db).map { issue }
            }
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Issue.find(req.parameters.get("issueID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { issue in
                issue.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}

struct CreateIssueData: Content {
    let title: String
    let year: Int
    let magazineID: UUID
}

