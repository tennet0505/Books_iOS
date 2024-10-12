//
//  Books_iOSTests.swift
//  Books-iOSTests
//
//  Created by Oleg Ten on 12/10/2024.
//

import XCTest
import Combine
@testable import Books_iOS

class Books_iOSTests: XCTestCase {
    
    var viewModel: BookViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        let mockService = MockAPIService()
        viewModel = BookViewModel(apiService: mockService)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }
    
    // Test that the loading state is properly set during a successful fetch
    func testFetchBooksSetsLoadingState_Success() {
        let expectation = XCTestExpectation(description: "Loading state should be set correctly")
        
        var loadingStates = [Bool]()
        
        viewModel.$isLoading
            .dropFirst() // Ignore the initial value
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 {
                    expectation.fulfill() // Expect two loading state changes (true, then false)
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchBooks()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(loadingStates, [true, false], "Loading state should be true then false when fetching books")
    }
    
    //Test Loading State for Failure
    func testFetchBooksSetsLoadingState_Failure() {
        let mockService = MockAPIService()
        mockService.shouldFail = true
        viewModel = BookViewModel(apiService: mockService) // Inject mock service
        
        let expectation = XCTestExpectation(description: "Loading state should be set correctly")
        
        var loadingStates = [Bool]()
        
        viewModel.$isLoading
            .dropFirst() // Ignore the initial value
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 {
                    expectation.fulfill() // Expect two loading state changes (true, then false)
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchBooks()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(loadingStates, [true, false], "Loading state should be true then false when fetching books fails")
    }
    
    //    Test Books Fetch Success
    func testFetchBooksSuccess() {
        let mockService = MockAPIService()
        viewModel = BookViewModel(apiService: mockService) // Inject mock service
        
        let expectation = XCTestExpectation(description: "Books should be fetched successfully")
        
        viewModel.$books
            .dropFirst() // Ignore the initial value
            .sink { books in
                if !books.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchBooks()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.books.count, 1, "Books array should contain one book")
        XCTAssertEqual(viewModel.books.first?.title, "Test Book", "First book title should be 'Test Book'")
    }
    
    // Test Books Fetch Failure
    func testFetchBooksFailure() {
        let mockService = MockAPIService()
        mockService.shouldFail = true
        viewModel = BookViewModel(apiService: mockService) // Inject mock service
        
        let expectation = XCTestExpectation(description: "Error message should be set on failure")
        
        viewModel.$errorMessage
            .dropFirst() // Ignore the initial value
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    XCTAssertEqual(errorMessage, "Network request failed.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchBooks()
        
        wait(for: [expectation], timeout: 1.0)
    }

    
}

class MockAPIService: APIServiceProtocol  {
    var shouldFail: Bool = false

    func fetchBooks() -> AnyPublisher<[Book], APIError> {
        if shouldFail {
            return Fail(error: APIError.requestFailed)
                .eraseToAnyPublisher()
        } else {
            let books = [Book(id: "1", title: "Test Book", author: "Test Author", imageUrl: "", bookDescription: "", isFavorite: false)]
            return Just(books)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
}
