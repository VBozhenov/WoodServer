import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let magazinesController = MagazinesController()
    let issuesController = IssuesController()
    
    try app.register(collection: magazinesController)
    try app.register(collection: issuesController)
}
