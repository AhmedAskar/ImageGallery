//
//  VFNetworkManagerTest.swift
//  Images-MVVMTests
//
//  Created by Ahmed Askar on 10/19/18.
//  Copyright © 2018 Ahmed Askar. All rights reserved.
//

import XCTest
import Alamofire

@testable import Images_MVVM

class VFNetworkManagerTest: XCTestCase {
    
    var networkManager: ASNetworkManager?
    var request = ASBaseRequest.init(path: .imageGallery(page: 1, gallerySection: "hot"))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = ASNetworkManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManager = nil
        super.tearDown()
    }
    
    func testFetchImages() {
        
        // Given A apiservice
        let networkManager = self.networkManager!
        
        // When fetch popular photo
        let expect = XCTestExpectation(description: "callback")
        networkManager.executeRequest(request: request, completionHandlerForExecuteRequest: { (result) in
            expect.fulfill()
            switch result {
            case .success(let response):
                do{
                    let response = response as! DataResponse<Any>
                    if let data = response.data {
                        let responseModel = try! JSONDecoder().decode(Gallery.self, from: data)
                        XCTAssertNotNil(responseModel)
                        XCTAssertNotNil(responseModel.data)
                        XCTAssertNotNil(responseModel.images)
                        XCTAssertNotNil(responseModel.images?[0].id)
                    }
                }
            case .failure(let error):
                XCTAssertNil(error)
            }
        })
        
        wait(for: [expect], timeout: 3.1)
    }
    
}
