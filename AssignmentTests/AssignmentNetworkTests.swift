//
//  AssignmentNetworkTests.swift
//  AssignmentTests
//
//  Created by Nitin Singh on 12/05/21.
//

import XCTest
@testable import Assignment

class AssignmentNetworkTests: XCTestCase {
    
    var sessionUnderTest : URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
        
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testValidCallToDomainAPIGetsStatusCodeForRent200(){
        // Given
        //given
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=19.01441&lon=72.847939&appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric")
        let promise = expectation(description: "Status code : 200")
        
        // when
        sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            // then
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else{
                    XCTFail("Status code = \(statusCode)")
                }
            }
        }.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    func testCallToDomainServerCompletes() {
            // Given
            let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=19.01441&lon=72.847939&appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric")
            let promise = expectation(description: "Call completes immediately by invoking completion handler")
            var statusCode : Int?
            var responseError : Error?
            
            // When
            sessionUnderTest.dataTask(with: url!) { (data, response, error) in
                statusCode = (response as? HTTPURLResponse)?.statusCode
                responseError = error
                promise.fulfill()
                }.resume()
            waitForExpectations(timeout: 5, handler: nil)
            
            // Then
            XCTAssertNil(responseError)
            XCTAssertEqual(statusCode, 200)
        }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
