
import XCTest
@testable import GitXCLib

final class GitTests: XCTestCase {
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	
	// # Private/Fileprivate
	private var sut: Git!
	private var shell: MockShell!
	
	//=======================================
	// MARK: Setup / Teardown
	//=======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		shell = MockShell()
		sut = Git(shell: shell)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	//=======================================
	// MARK: Tests
	//=======================================
	//------------------------------------
	// MARK: status()
	//------------------------------------
	func testStatus() {
		
		// GIVEN
		
		// WHEN
		let result: String = sut.status()
		
		// THEN
		XCTAssertEqual("git status", result)
	}

	//------------------------------------
	// MARK: addAll()
	//------------------------------------
	func testAddAll() {
		
		// GIVEN
		
		// WHEN
		let result: String = sut.addAll()
		
		// THEN
		XCTAssertEqual("git add .", result)
	}

	//------------------------------------
	// MARK: commit()
	//------------------------------------
	func testCommit() {
		
		// GIVEN
		let message: String = "a commit msg"
		
		// WHEN
		let result: String = sut.commit(message)
		
		// THEN
		XCTAssertEqual("git commit -m '\(message)'", result)
	}

	//------------------------------------
	// MARK: merge()
	//------------------------------------
	func testMerge() {
		
		// GIVEN
		let branchName: String = "someOtherBranch"
		
		// WHEN
		let result: String = sut.merge(branchName)
		
		// THEN
		XCTAssertEqual("git merge \(branchName)", result)
	}

	//------------------------------------
	// MARK: pull()
	//------------------------------------
	func testPull_WithBranchName() {
		
		// GIVEN
		let branchName: String = "someOtherBranch"
		
		// WHEN
		let result: String = sut.pull(branchName)
		
		// THEN
		XCTAssertEqual("git pull origin \(branchName)", result)
	}

	func testPull_NoBranchName() {
		
		// GIVEN
		
		// WHEN
		let result: String = sut.pull(nil)
		
		// THEN
		XCTAssertEqual("git pull", result)
	}

	//------------------------------------
	// MARK: currentBranch()
	//------------------------------------
	func testCurrentBranch() {
		
		// GIVEN
		
		// WHEN
		let branch: String = sut.currentBranch()
		
		// THEN
		XCTAssertEqual("git branch --show-current", branch)
	}
	
	//------------------------------------
	// MARK: commitNeeded()
	//------------------------------------
	func testCommitNeeded() {
		
		// GIVEN
		
		// WHEN
		let needed: Bool = sut.commitNeeded()
		
		// THEN
		XCTAssertEqual(true, needed)
	}
	
	func testStatusContainsErrors() {
		
		// GIVEN
		
		// WHEN
		let containsErrors: Bool = sut.statusContainsErrors()
		
		// THEN
		XCTAssertFalse(containsErrors)
	}

	func testContainsErrors() {
		
		// GIVEN
		let text: String = ""
		
		// WHEN
		let containsErrors: Bool = sut.containsErrors(text)
		
		// THEN
		XCTAssertFalse(containsErrors)
	}

	//------------------------------------
	// MARK: mentionsConflict(_:)
	//------------------------------------
	func testMentionsConflict_DoesNot_ReturnsFalse() {
		
		// GIVEN
		let text: String = "lorem ipsum blah blah"
		
		// WHEN
		let result: Bool = sut.mentionsConflict(text)
		
		// THEN
		XCTAssertFalse(result)
	}
	
	func testMentionsConflict_Does_ReturnsTrue() {
		
		// GIVEN
		let text: String = "(fix conflicts)"
		
		// WHEN
		let result: Bool = sut.mentionsConflict(text)
		
		// THEN
		XCTAssertTrue(result)
	}
	
	//------------------------------------
	// MARK: unmergedPaths(fromStatus:)
	//------------------------------------
	func testUnmergedPathsFromStatus_None_ReturnsNil() {
		
		// GIVEN
		let text: String = "lorem ipsum blah blah"

		// WHEN
		let paths: [String]? = sut.unmergedPaths(fromStatus: text)
		
		// THEN
		XCTAssertNil(paths)
	}

	func testUnmergedPathsFromStatus_Some_ReturnsPaths() {
		
		// GIVEN
		let text: String = """
		On branch mergeTests/branchOne
		You have unmerged paths.
		  (fix conflicts and run "git commit")
		  (use "git merge --abort" to abort the merge)

		Unmerged paths:
		  (use "git add <file>..." to mark resolution)
			both modified:   MoSProd/Supporting Files/MoSProd-Info.plist
			both modified:   NotificationContent/NoteContent-Info.plist
			both modified:   Watch Extension/Supporting Files/WatchExtension-Info.plist
			both modified:   Watch/Watch-Info.plist

		no changes added to commit (use "git add" and/or "git commit -a")
		"""

		// WHEN
		let paths: [String]? = sut.unmergedPaths(fromStatus: text)
		
		// THEN
		XCTAssertNotNil(paths)
		XCTAssertEqual(4, paths?.count)
	}
}

