//
//  Rubric.swift
//  
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Vapor
import Fluent

final class Rubric: Model, Content {
    static let schema = "rubrics"

    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Parent(key: "issueID")
    var issue: Issue
    
    @Children(for: \.$rubric)
    var articles: [Article]

    init() {}

    init(id: UUID? = nil, title: String, issueID: Issue.IDValue) {
        self.id = id
        self.title = title
        self.$issue.id = issueID
    }
}
