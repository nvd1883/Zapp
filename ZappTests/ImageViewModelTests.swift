//
//  ImageViewModelTests.swift
//  ZappTests
//
//  Created by Nived Pradeep on 18/01/24.
//

import XCTest
@testable import Zapp

final class ImageViewModelTests: XCTestCase {
    var viewModel:ImageViewModel!
    
    override func setUpWithError() throws {
        viewModel = ImageViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testNumberOfImagesInitiallyZero() throws {
        XCTAssertEqual(viewModel.numberOfImages(), 0)
    }
    
    //MARK: - Test loadmoreImages function
    
    func testLoadMoreImagesSuccess() {
        let expectation = XCTestExpectation(description: "Load more images")
        let initialCount = viewModel.numberOfImages()
        
        viewModel.loadMoreImages{result in
            switch result {
            case .success:
                let expectedCountAfterLoading = initialCount + 20
                XCTAssertEqual(self.viewModel.numberOfImages(), expectedCountAfterLoading)
            case .failure:
                XCTFail("Load More Images Failed")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadImageWithCaching() {
        let testURL = URL(string: "https://source.unsplash.com/random")!
        
        let expectation = XCTestExpectation(description: "Load image from URL with caching")
        viewModel.loadImage(with: testURL){ image in
            XCTAssertNotNil(image)
            self.viewModel.loadImage(with: testURL) {image1 in
                XCTAssertNotNil(image1)
                XCTAssertEqual(image, image1)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDelegateImagesDidUpdate() {
        var delegateMock = ViewModelDelegateMock()
        viewModel.delegate = delegateMock
        viewModel.delegate?.imagesDidUpdate()
        XCTAssertTrue(delegateMock.imagesDidUpdateCalled)
    }
    
    func testDelegateImagesDidFailFetching() {
        var delegateMock = ViewModelDelegateMock()
        viewModel.delegate = delegateMock
        viewModel.delegate?.didFailFetchingImages(error: NSError(domain: "TestErrorDoman", code: 123, userInfo: nil))
        XCTAssertTrue(delegateMock.didFailFetchingImagesCalled)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class ViewModelDelegateMock:ImageViewModelDelegate {
    var imagesDidUpdateCalled = false
    var didFailFetchingImagesCalled = false
    
    func imagesDidUpdate() {
        imagesDidUpdateCalled = true
    }
    
    func didFailFetchingImages(error: Error) {
        didFailFetchingImagesCalled = true
    }
    
    
}
