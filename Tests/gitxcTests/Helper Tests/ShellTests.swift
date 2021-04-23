

import XCTest
@testable import GitXCLib

final class ShellTests: XCTestCase {
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	
	// # Private/Fileprivate
	private var sut: Shell!
	
	//=======================================
	// MARK: Setup / Teardown
	//=======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = Shell()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	//=======================================
	// MARK: Tests
	//=======================================
	//------------------------------------
	// MARK: perform(command:)
	//------------------------------------
	func testPerformCommand() {
		
		// GIVEN
		let command: String = "ls"
		
		// WHEN
		let result: String = sut.perform(command)
		
		// THEN
		XCTAssertFalse(result.isEmpty)
//		XCTAssertTrue(result.contains("BastardTests.xctest"))
	}
	
}

