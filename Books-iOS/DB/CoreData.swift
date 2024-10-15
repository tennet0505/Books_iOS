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
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let books = try context.fetch(fetchRequest)
            return books
        } catch let error as NSError {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    // Add or update a book
    func addOrUpdateBook(id: String, title: String, author: String, imageUrl: String, bookDescription: String, isFavorite: Bool, pdfUrl: String, isPopular: Bool) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(fetchRequest)

            if let existingBook = results.first {
                // Update existing book
                existingBook.title = title
                existingBook.author = author
                existingBook.imageUrl = imageUrl
                existingBook.bookDescription = bookDescription
                existingBook.isFavorite = isFavorite
                existingBook.isPopular = isPopular
                existingBook.pdfUrl = pdfUrl
                
                print("Updated book with ID: \(id)")
            } else {
                // Add new book
                let newBook = BookEntity(context: context)
                newBook.id = id
                newBook.title = title
                newBook.author = author
                newBook.imageUrl = imageUrl
                newBook.bookDescription = bookDescription
                newBook.isFavorite = isFavorite
                newBook.isPopular = isPopular
                newBook.pdfUrl = pdfUrl
            }
            saveContext()
        } catch {
            print("Error fetching or saving book: \(error.localizedDescription)")
        }
    }
    
    func removeAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BookEntity") 
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            // Optionally save the context
            try persistentContainer.viewContext.save()
        } catch {
            print("Error deleting books: \(error)")
        }
    }

    
    func updateBook(book: Book, isFavorite: Bool) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let bookEntity = results.first {
                bookEntity.isFavorite = isFavorite
                try context.save()
                NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: book)
            }
        } catch {
            print("Error updating book: \(error.localizedDescription)")
        }
    }
    
    // Fetch book by ID
    func fetchBookByID(_ id: String) -> BookEntity? {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let books = try context.fetch(fetchRequest)
            return books.first
        } catch {
            print("Failed to fetch book by ID: \(error)")
            return nil
        }
    }
    
    // Fetch my library
    func fetchFavoriteBooks() -> [BookEntity] {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        // Set the predicate to filter only favorite books
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        do {
            let favoriteBooks = try CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return favoriteBooks
        } catch {
            print("Failed to fetch favorite books: \(error)")
            return []
        }
    }
    
    func fetchFavoriteBookIDs() -> Set<String> {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            let favoriteBooks = try CoreDataManager.shared.context.fetch(request)
            return Set(favoriteBooks.map { $0.id ?? "" })
        } catch {
            print("Failed to fetch favorite book IDs: \(error)")
            return []
        }
    }
    
    
    
    
    
    // Delete a book
    func deleteBook(book: BookEntity) {
        context.delete(book)
        saveContext()
    }
    
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            print("All books deleted successfully.")
        } catch let error as NSError {
            print("Error deleting all books: \(error.localizedDescription)")
        }
    }
}
