//
//  ArticlesController.swift
//  
//
//  Created by Vladimir Bozhenov on 28.01.2022.
//

import Vapor
import Fluent
import Foundation

struct ArticlesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let articlesRoute = routes.grouped("api", "articles")
        
        articlesRoute.get("all", use: getAllHandler)
        articlesRoute.get("issue", ":issueID", use: getIssueArticlesHandler)
//        articlesRoute.get("rubric", ":rubricID", use: getRubricArticlesHandler)
        articlesRoute.post(use: createHandler)
        articlesRoute.put(":articleID", use: updateHandler)
        articlesRoute.delete(":articleID", use: deleteHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Article]> {
        return Article
            .query(on: req.db)
            .sort(\.$title, .ascending)
            .with(\.$issue)
//            .with(\.$rubric)
            .all()
    }
    
    func getIssueArticlesHandler(_ req: Request) throws -> EventLoopFuture<[Article]> {
        let stringIssueID = req.parameters.get("issueID") ?? ""
        let issueID = UUID(uuidString: stringIssueID) ?? UUID()
        return Article
            .query(on: req.db)
            .filter(\.$issue.$id == issueID)
            .sort(\.$title, .ascending)
            .with(\.$issue)
//            .with(\.$rubric)
            .all()
    }
    
//    func getRubricArticlesHandler(_ req: Request) throws -> EventLoopFuture<[Article]> {
//        let stringRubricID = req.parameters.get("rubricID") ?? ""
//        let rubricID = UUID(uuidString: stringRubricID) ?? UUID()
//        return Article
//            .query(on: req.db)
//            .filter(\.$rubric.$id == rubricID)
//            .sort(\.$title, .ascending)
//            .with(\.$issue)
//            .with(\.$rubric)
//            .all()
//    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Article> {
        let data = try req.content.decode(CreateArticleData.self)
        let article = Article(title: data.title, page: data.page, description: data.description, issueID: data.issueID)
        return article.save(on: req.db).map { article }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Article> {
        let updateData = try req.content.decode(CreateArticleData.self)
        return Article
            .find(req.parameters.get("articleID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { article in
                article.title = updateData.title
                article.page = updateData.page
                article.description = updateData.description
//                article.$rubric.id = updateData.rubricID
                article.$issue.id = updateData.issueID
                return article.save(on: req.db).map { article }
            }
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Article.find(req.parameters.get("articleID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { article in
                article.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}

struct CreateArticleData: Content {
    let title: String
    let page: Int
    let description: String?
    let issueID: UUID
//    let rubricID: UUID?
}


