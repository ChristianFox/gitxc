import XCTest
@testable import GitXCLib

final class InfoPlistResolverTests: XCTestCase {

    //------------------------------------
    // MARK: Properties
    //------------------------------------
    // # Public/Internal/Open
    
    // # Private/Fileprivate
    private var sut: InfoPlistResolver!
    
    //=======================================
    // MARK: Setup / Teardown
    //=======================================
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = InfoPlistResolver()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //=======================================
    // MARK: Tests
    //=======================================
    //------------------------------------
    // MARK: resolveBundleVersionConflict()
    //------------------------------------
    func testResolveBundleVersionConflict_NoConflict_ReturnsNoConflict() throws {
        
        // GIVEN
        let conflicted: String = FakeBuilder.stringWithoutConflict()
        
        // WHEN
        let result: PlistConflictResult = try sut.resolveBundleVersionConflict(conflicted)

        // THEN
        switch result {
        case .noConflict:
            break
        default:
            XCTFail()
        }
    }

    func testResolveBundleVersionConflict_TwoConflicts_ThrowsManualResolutionNeeded() throws {
        
        // GIVEN
        let conflicted: String = FakeBuilder.stringWithTwoConflicts()
        
        // WHEN
        let result: PlistConflictResult = try sut.resolveBundleVersionConflict(conflicted)

        // THEN
        switch result {
        case .manualResolutionNeeded:
            break
        default:
            XCTFail()
        }
    }

    func testResolveBundleVersionConflict_TwoChangesInConflict_ThrowsManualResolutionNeeded() throws {
        
        // GIVEN
        let conflicted: String = FakeBuilder.stringWithTwoChangesInConflict()
        
        // WHEN
        let result: PlistConflictResult = try sut.resolveBundleVersionConflict(conflicted)

        // THEN
        switch result {
        case .manualResolutionNeeded:
            break
        default:
            XCTFail()
        }
    }
    
    func testResolveBundleVersionConflict_OtherConflict_ThrowsManualResolutionNeeded() throws {
        
        // GIVEN
        let conflicted: String = FakeBuilder.stringWithOtherConflict()
        
        // WHEN
        let result: PlistConflictResult = try sut.resolveBundleVersionConflict(conflicted)

        // THEN
        switch result {
        case .manualResolutionNeeded:
            break
        default:
            XCTFail()
        }
    }


    func testResolveBundleVersionConflict_Misformatted_ThrowsInvalidPlist() throws {
        
        // GIVEN
        let conflicted: String = FakeBuilder.misformattedStringWithConflict()
        
        // WHEN
        do {
            _ = try sut.resolveBundleVersionConflict(conflicted)
            XCTFail()
        } catch {
            // THEN
            XCTAssertEqual(PlistConflictError.invalidPlist, error as! PlistConflictError)
        }
    }

    func testResolveBundleVersionConflict_Valid_ResolvesConflict() throws {
        
        // GIVEN
        let conflicted: String = FakeBuilder.stringWithConflict()
        
        // WHEN
        let result: PlistConflictResult = try sut.resolveBundleVersionConflict(conflicted)

        // THEN
        switch result {
        case .resolved(let dictionary, let url):
            XCTAssertNotNil(dictionary["CFBundleVersion"])
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
            let readPlist: [String: Any]? = try PlistHelper.plistDictionaryFromURL(url)
            XCTAssertNotNil(readPlist)
            XCTAssertEqual(readPlist?.count, dictionary.count)
            XCTAssertEqual(readPlist?["CFBundleVersion"] as! String, dictionary["CFBundleVersion"] as! String)
        default:
            XCTFail()
        }
    }

}
