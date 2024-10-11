//
//  CoreData.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    // Reference to the managed object context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Books_iOS") // Your data model name
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Save context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchBooks() -> [BookEntity] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let books = try context.fetch(fetchRequest)
            return books
        } catch let error as NSError {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    
    // Add a book
    func addBook(id: String, title: String, author: String, imageUrl: String, bookDescription: String) {
        let book = BookEntity(context: context)
        book.id = id
        book.title = title
        book.author = author
        book.imageUrl = imageUrl
        book.bookDescription = bookDescription
        book.isFavorite = false
        
        saveContext()
    }
    
    // Update a book
    func updateBook(book: BookEntity, isFavorite: Bool) {
        book.isFavorite = isFavorite
        saveContext()
    }
    
    // Delete a book
    func deleteBook(book: BookEntity) {
        context.delete(book)
        saveContext()
    }
}
