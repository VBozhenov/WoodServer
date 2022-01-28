import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let magazinesController = MagazinesController()
    let issuesController = IssuesController()
    let rubricsController = RubricsController()
    
    try app.register(collection: magazinesController)
    try app.register(collection: issuesController)
    try app.register(collection: rubricsController)
}
