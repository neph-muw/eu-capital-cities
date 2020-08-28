//
//  eu_capital_citiesTests.swift
//  eu-capital-citiesTests
//
//  Created by Roman Mykitchak on 19/08/2020.
//

import XCTest
@testable import eu_capital_cities

class eu_capital_citiesTests: XCTestCase {
    
    var cities: [EuCity]!
    
    override class func setUp() {
        super.setUp()
        //
    }
    
    override class func tearDown() {
        //
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let jsonString = """
        [
            {
                "id": "1",
                "name": "Berlin",
                "description": "Berlin is the capital and largest city of Germany by bot area and population. Its 3,769,495 (2019) inhabitants make it the most populous city proper of the European Union. The city is one of Germany's 16 federal states. It is surrounded by the state of Brandenburg, and contiguous with Potsdam, Brandenburg's capital. The two cities are at the center of the Berlin-Brandenburg capital region, which is, with about six million inhabitants and an area of more than 30,000 km², Germany's third-largest metropolitan region after the Rhine-Ruhr and Rhine-Main regions.",
                "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Cityscape_Berlin.jpg/250px-Cityscape_Berlin.jpg",
                "latitude": "10.46372",
                "longitude": "1.49129"
            },
            {
                "id": "2",
                "name": "Madrid",
                "description": "Madrid (/məˈdrɪd/, Spanish: [maˈðɾið])[n. 1] is the capital and most populous city of Spain.",
                "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/5/5c/Madrid_Cityscape.jpg",
                "latitude": "40.383333",
                "longitude": "-3.716667"
            },
            {
                "id": "3",
                "name": "Rome",
                "description": "Rome (Italian and Latin: Roma [ˈroːma] (About this soundlisten)) is the capital city and a special comune of Italy (named Comune di Roma Capitale) as well as the capital of the Lazio region.",
                "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/f/f5/Rome_Skyline_%288012016319%29.jpg",
                "latitude": "41.883333",
                "longitude": "12.5"
            }
        ]
        """
        guard let output = jsonString.data(using: .utf8) else { return }
        cities = try JSONDecoder().decode([EuCity].self, from: output)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cities = nil
    }
    
    func testFavourited() {
        let city = cities.first
        XCTAssertEqual(city?.name, "Berlin", "City is not Berlin")
        XCTAssertEqual(city?.favourited, nil, "City is favourited from init, but shouldn't")
        
        city?.favourited = true
        XCTAssertEqual(city?.favourited, true, "City is not favourited, but should")
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
