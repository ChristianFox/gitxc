
import XCTest
@testable import GitXCLib

final class StringOccurancesTests: XCTestCase {
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    // # Public/Internal/Open
    
    // # Private/Fileprivate
    
    //=======================================
    // MARK: Setup / Teardown
    //=======================================
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    //=======================================
    // MARK: Tests
    //=======================================
    //------------------------------------
    // MARK: occurances(of substring:)
    //------------------------------------
    func testOccurancesOfSubstring_ShouldBeNone() {
        
        // GIVEN
        let text: String = "one two two three three three"
        
        // WHEN
        let occurances: Int = text.occurances(of: "none")
        
        // THEN
        XCTAssertEqual(0, occurances)
    }

    func testOccurancesOfSubstring_ShouldBeOne() {
        
        // GIVEN
        let text: String = "one two two three three three"
        
        // WHEN
        let occurances: Int = text.occurances(of: "one")
        
        // THEN
        XCTAssertEqual(1, occurances)
    }

    func testOccurancesOfSubstring_ShouldBeTwo() {
        
        // GIVEN
        let text: String = "one two two three three three"
        
        // WHEN
        let occurances: Int = text.occurances(of: "two")
        
        // THEN
        XCTAssertEqual(2, occurances)
    }

    func testOccurancesOfSubstring_ShouldBeThree() {
        
        // GIVEN
        let text: String = "one two two three three three"
        
        // WHEN
        let occurances: Int = text.occurances(of: "three")
        
        // THEN
        XCTAssertEqual(3, occurances)
    }

}

