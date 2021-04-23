
import XCTest
@testable import GitXCLib

final class FileManagerFindTests: XCTestCase {
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	
	// # Private/Fileprivate
	private var sut: FileManager!
	
	//=======================================
	// MARK: Setup / Teardown
	//=======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = FileManager.default
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	//=======================================
	// MARK: Tests
	//=======================================
	//------------------------------------
	// MARK: findFiles(with: in:)
	//------------------------------------
	/*
	Empty URL defaults to /private/tmp so this test fails
	*/	
//	func testFindFiles_EmptyURL_ThrowsURLNeedsToBeMoreSpecific() {
//
//		// GIVEN
//		let suffix: String = ".txt"
//		let directory: URL = URL(fileURLWithPath: "")
//		print("count: \(directory.path.count), path: \(directory.path)")
//
//		// WHEN
//		do {
//			_ = try sut.findFiles(with: suffix, in: directory)
//			XCTFail()
//		} catch {
//			// THEN
//			XCTAssertEqual(FileFinderError.urlNeedsToBeMoreSpecific, error as! FileFinderError)
//		}
//	}

	func testFindFiles_ShortURL_ThrowsURLNeedsToBeMoreSpecific() {
		
		// GIVEN
		let suffix: String = ".txt"
		let directory: URL = URL(fileURLWithPath: "/Volumes")
		print("count: \(directory.path.count), path: \(directory.path)")

		// WHEN
		do {
			_ = try sut.findFiles(withSuffix: suffix, in: directory)
			XCTFail()
		} catch {
			// THEN
			XCTAssertEqual(FileFinderError.urlNeedsToBeMoreSpecific, error as! FileFinderError)
		}
	}

	func testFindFiles_EmptySuffix_ThrowsSearchSuffixIsEmpty() {
		
		// GIVEN
		let suffix: String = ""
		let directory: URL = URL(fileURLWithPath: "/Volumes/AVolume")
		
		// WHEN
		do {
			_ = try sut.findFiles(withSuffix: suffix, in: directory)
			XCTFail()
		} catch {
			// THEN
			XCTAssertEqual(FileFinderError.searchSuffixIsEmpty, error as! FileFinderError)
		}
	}

	func testFindFiles_xctestFilesInProductsDirectory_ReturnsOneFilePath() throws {
		
		// GIVEN
		let suffix: String = ".xctest"
		let directory: URL = productsDirectory
		
		// WHEN
		let files: [String] = try sut.findFiles(withSuffix: suffix, in: directory)
		
		// THEN
		XCTAssertEqual(1, files.count)
	}

	func testFindFiles_InfoPlistsInProductsDirectory_ReturnsOneFilePath() throws {
		
		// GIVEN
		let suffix: String = "Info.plist"
		let directory: URL = productsDirectory

		// WHEN
		let files: [String] = try sut.findFiles(withSuffix: suffix, in: directory)
		
		// THEN
		XCTAssertEqual(1, files.count)
	}
}

private extension FileManagerFindTests {
	
	/// Returns path to the built products directory.
	var productsDirectory: URL {
	  #if os(macOS)
		for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
			return bundle.bundleURL.deletingLastPathComponent()
		}
		fatalError("couldn't find the products directory")
	  #else
		return Bundle.main.bundleURL
	  #endif
	}


}
