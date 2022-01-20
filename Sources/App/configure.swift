import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    //    app.http.server.configuration.hostname = "192.168.100.7"
    //    app.http.server.configuration.port = 8080
    
    app.migrations.add(CreateMagazine())
    app.migrations.add(CreateIssue())
    app.migrations.add(CreateRubric())
    app.migrations.add(CreateArticle())

    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    
    app.views.use(.leaf)
    
    
    
    // register routes
    try routes(app)
}
