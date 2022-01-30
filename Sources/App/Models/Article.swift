//
//  Article.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Vapor
import Fluent

final class Article: Model, Content {
    static let schema = "articles"

    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "page")
    var page: Int
    
    @OptionalField(key: "description")
    var description: String?
    
    @Parent(key: "issueID")
    var issue: Issue
    
//    @OptionalParent(key: "rubricID")
//    var rubric: Rubric?

    init() {}

    init(id: UUID? = nil, title: String, page: Int, description: String? = nil, issueID: Issue.IDValue) {
        self.id = id
        self.title = title
        self.page = page
        self.description = description
        self.$issue.id = issueID
//        self.$rubric.id = rubricID
    }
}
