//
//  VFImageGalleryViewModelTest.swift
//  Images-MVVMTests
//
//  Created by Ahmed Askar on 10/19/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import XCTest
@testable import Images_MVVM

class VFImageGalleryViewModelTest: XCTestCase {
    
    var viewModelTest: ASImageGalleryViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockNetworkManager = MockNetworkManager()
        viewModelTest = ASImageGalleryViewModel(networkService: mockNetworkManager)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockNetworkManager = nil
        viewModelTest = nil
        super.tearDown()
    }
    
    func testFetchImages() {
        
        mockNetworkManager.gallery = Gallery(data: [Image](), status: 200, success: true)
        viewModelTest.initFetch(page: 1, gallerySection: "hot", showViral: true)
        XCTAssert(mockNetworkManager!.isFetchImageCalled)
    }
    
    func testFetchImagesFail() {
        
        viewModelTest.initFetch(page: 1, gallerySection: "hot", showViral: true)
        
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            let requestError = NSError(domain: "startRequst", code: 1, userInfo: userInfo)
            mockNetworkManager.fetchFail(error: requestError)
            XCTAssertEqual(viewModelTest.alertMessage, requestError.localizedDescription)
        }
        
        let errorString = "Error"
        sendError("Error while fetching request: \(errorString)")
    }
    
    func testImagesViewModel() {
        
        let galleryModel = StubGenerator().stubGallery()
        mockNetworkManager.gallery = galleryModel
        
        let expect = XCTestExpectation(description: "reload closure triggered")
        viewModelTest.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        viewModelTest.initFetch(page: 1, gallerySection: "hot", showViral: true)
        mockNetworkManager.fetchSuccess()
        
        // Number of cell view model is equal to the number of products
        XCTAssertEqual(40, galleryModel.images!.count)
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
    }
    
    func testLoadingWhenFetching() {
        
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        viewModelTest.updateLoadingStatus = { [weak viewModelTest] in
            loadingStatus = viewModelTest!.isLoading
            expect.fulfill()
        }

        mockNetworkManager.gallery = StubGenerator().stubGallery()
        viewModelTest.initFetch(page: 1, gallerySection: "hot", showViral: true)
        XCTAssertTrue(loadingStatus)
        
        mockNetworkManager!.fetchSuccess()
        XCTAssertFalse(loadingStatus)
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testGetImage() {
        
        goToFetchImagesFinished()
        let indexPath = IndexPath(row: 0, section: 0)
        let testImage = mockNetworkManager.gallery?.images![indexPath.row]
        let image = viewModelTest.getImage(indexPath: indexPath)
        XCTAssertEqual(testImage?.id,image.id)
    }
}

//MARK: State control
extension VFImageGalleryViewModelTest {
    private func goToFetchImagesFinished() {
        mockNetworkManager.gallery = StubGenerator().stubGallery()
        viewModelTest.initFetch(page: 1, gallerySection: "hot", showViral: true)
        mockNetworkManager.fetchSuccess()
    }
}

class MockNetworkManager: VFNetworkManagerProtocol {
    
    var isFetchImageCalled = false
    
    var gallery: Gallery?
    var completionForImages: ((Result)->())!
    
    func getImagesGallery(page: Int, gallerySection: String, _ parameter: [String : String], completionHandlerForImages: @escaping (Result) -> ()) {
        isFetchImageCalled = true
        completionForImages = completionHandlerForImages
    }
    
    func fetchSuccess() {
        completionForImages(Result.success(gallery!))
    }
    
    func fetchFail(error: Error) {
        completionForImages(Result.failure(error))
    }
}

class StubGenerator {
    
    func stubImages() -> [Image] {
        if let path = Bundle.main.path(forResource: "hot", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let productResponse = try! JSONDecoder().decode(Gallery.self, from: data)
            return productResponse.images!
        }
        return []
    }
    
    func stubGallery() -> Gallery {
        if let path = Bundle.main.path(forResource: "hot", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let productResponse = try! JSONDecoder().decode(Gallery.self, from: data)
            return productResponse
        }
        return Gallery(data: [Image](), status: 200, success: true)
    }
}
