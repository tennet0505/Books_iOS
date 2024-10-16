//
//  Books_iOSTests.swift
//  Books-iOSTests
//
//  Created by Oleg Ten on 12/10/2024.
//

import XCTest
import Combine
@testable import Books_iOS
import PDFKit

import XCTest
import Combine

class Books_iOSTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var cancellables: Set<AnyCancellable>!
    var pdfViewController: PDFViewController!
    var mockPDFView: PDFView!
    
    override func setUpWithError() throws {
        let mockService = MockAPIService()
        viewModel = SearchViewModel(apiService: mockService)
        cancellables = []
        pdfViewController = PDFViewController()
        mockPDFView = PDFView()
        pdfViewController.pdfView = mockPDFView
    }
    
    override func tearDown() {
        pdfViewController = nil
        mockPDFView = nil
        super.tearDown()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }
    
    func testPDFLoading() {
        // Given
        let urlString = "https://www.soundczech.cz/temp/lorem-ipsum.pdf"
        pdfViewController.pdfUrl = urlString
        
        // When
        pdfViewController.loadPDF(from: URL(string: urlString)!)
        
        // Wait for a bit to ensure asynchronous loading
        let expectation = self.expectation(description: "PDF loading expectation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then
            XCTAssertNotNil(self.mockPDFView.document, "PDF document should not be nil after loading.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchBooks() {
        // Given
        let expectation = self.expectation(description: "Books fetched successfully")
        
        // When
        viewModel.fetchBooks()
        
        // Then
        viewModel.$books
            .dropFirst() // Skip the initial value
            .sink(receiveValue: { books in
                XCTAssertEqual(books.count, 1, "There should be 1 book fetched.")
                XCTAssertEqual(books.first?.title, "Test Book", "The title of the book should be 'Test Book'.")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFilterBooks() {
        // Given
        viewModel.fetchBooks() // Fetching books
        let expectation = self.expectation(description: "Books filtered successfully")
        
        // When
        viewModel.filterBooks(query: "Test") // Assuming filterBooks is implemented
        
        // Then
        viewModel.$filteredBooks
            .dropFirst()
            .sink(receiveValue: { filteredBooks in
                XCTAssertEqual(filteredBooks.count, 1, "There should be 1 filtered book.")
                XCTAssertEqual(filteredBooks.first?.title, "Test Book", "The filtered book title should be 'Test Book'.")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class MockAPIService: APIServiceProtocol  {
    var shouldFail: Bool = false
    
    func fetchBooks() -> AnyPublisher<[Book], APIError> {
        if shouldFail {
            return Fail(error: APIError.requestFailed)
                .eraseToAnyPublisher()
        } else {
            let books = [
                Book(id: "1", title: "Test Book", author: "Test Author", imageUrl: "", bookDescription: "", isFavorite: false, pdfUrl: "")
            ]
            return Just(books)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
}
