//
//  WorldBeersTests.swift
//  WorldBeersTests
//
//  Created by Pavarit Chandhaprayoon on 16/3/2566 BE.
//

import XCTest
import PactSwift
@testable import WorldBeers

final class WorldBeersTests: XCTestCase {
    
    static var mockService = MockService(
        consumer: "demo-consumer",
        provider: "demo-provider",
        writePactTo: URL(fileURLWithPath: #file, isDirectory: true)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "/PactContract")
    )
    
    var expectedBeerList: [BeerResponse]?
    

    override func setUpWithError() throws {
        let rawData = """
         [{
            "name": "BeerName",
            "tagline": "beer tag line",
            "image_url": "https://beer.com/name/image.jpg",
            "abv": 4.2,
            "ibu": 55
         }]
         """.data(using: .utf8)!
        self.expectedBeerList = try JSONDecoder().decode([BeerResponse].self, from: rawData)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUsers() {
        WorldBeersTests.mockService
            .uponReceiving("A request to get a beer list")
            .given(
                ProviderState(
                    description: "a beer exist",
                    params: ["brand":"Heineken"]
                )
            ).withRequest(
                method: .GET,
                path: "/v2/beers"
            ).willRespondWith(
                status: 200,
                body: [
                    "name": expectedBeerList![0].name!,
                    "tagline": expectedBeerList![0].tagline!,
                    "image_url": expectedBeerList![0].image_url!,
                    "abv": expectedBeerList![0].abv!,
                    "ibu": expectedBeerList![0].ibu!
                ]
            )
        
        let apiClient = ApiManager()
        
        WorldBeersTests.mockService.run(timeout:20) { [unowned self] mockServiceURL, done in
            apiClient.retrieveBeers(toURL: "\(mockServiceURL)/v2/beers") { [weak self] response in
                XCTAssertEqual(
                    response,
                    self!.expectedBeerList
                )
                done()
            } fail: { _ in
                done()
            }
        }
    }
}
