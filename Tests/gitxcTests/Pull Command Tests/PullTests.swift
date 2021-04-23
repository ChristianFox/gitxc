
import XCTest
@testable import GitXCLib

final class PullTests: XCTestCase {
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	
	// # Private/Fileprivate
	private var shell: MockShell!
	private var fileManager: MockFileManager!

	//=======================================
	// MARK: Setup / Teardown
	//=======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		shell = MockShell()
		fileManager = MockFileManager()
		fileManager._currentDirectoryPath = "/Volumes/iMacStorage/_Dev - Projects/Git Projects/MergeTestProjects/TestProject"
	}
	
	override func tearDownWithError() throws {
		shell = nil
		fileManager = nil
		try super.tearDownWithError()
	}

	//=======================================
	// MARK: Tests
	//=======================================
	//------------------------------------
	// MARK: run()
	//------------------------------------
	func testRun_NoConflicts_DoesNotThrow() {

		// GIVEN
		var git = MockGit(mockShell: shell)
		git.pullReturnValue = ""
		git.mentionsConflictReturnValue = false
		git.statusReturnValue = ""
		let resolver = MockInfoPlistResolver()
		let helper = MockMergeHelper(resolver: resolver, fileManager: fileManager)
		var sut = Pull(git: git, helper: helper)
		sut.branchName = "anyBranch"
		sut.verbose = true
		sut.commit = true

		// WHEN, THEN
		XCTAssertNoThrow(try sut.run())
	}

	func testRun_GitHasConflicts_PlistsNoConflicts_DoesNotThrow() {

		// GIVEN
		var git = MockGit(mockShell: shell)
		git.pullReturnValue = ""
		git.mentionsConflictReturnValue = true
		git.statusReturnValue = ""
		var resolver = MockInfoPlistResolver()
		resolver.resultReturnValue = .noConflict
		let helper = MockMergeHelper(resolver: resolver, fileManager: fileManager)
		helper.resultsReturnValue = ([.noConflict], [], [])
		var sut = Pull(git: git, helper: helper)
		sut.branchName = "anyBranch"
		sut.verbose = true
		sut.commit = true

		// WHEN, THEN
		XCTAssertNoThrow(try sut.run())
	}

	func testRun_GitHasConflicts_PlistConflictsResolved_CommmitDisabled_DoesNotAttemptToCommit() {

		// GIVEN
		var git = MockGit(mockShell: shell)
		git.pullReturnValue = ""
		git.mentionsConflictReturnValue = true
		git.statusReturnValue = ""
		var resolver = MockInfoPlistResolver()
		resolver.resultReturnValue = PlistConflictResult.resolved(dictionary: [:], url: URL(fileURLWithPath: ""))
		let helper = MockMergeHelper(resolver: resolver, fileManager: fileManager)
		helper.resultsReturnValue = ([], [], [.resolved(dictionary: [:], url: URL(fileURLWithPath: ""))])
		var sut = Pull(git: git, helper: helper)
		sut.branchName = "anyBranch"
		sut.verbose = true
		sut.commit = false

		// WHEN
		XCTAssertNoThrow(try sut.run())
		
		// THEN
		XCTAssertFalse(helper.didCallCommitMerge)
	}

	// Not very useful because it tests the mock class and it requires an info.plist file to be present and writable
//	func testRun_GitHasConflicts_PlistConflictsResolved_CommmitEnabled_AttemptsToCommit() {
//
//		// GIVEN
//		var git = MockGit(mockShell: shell)
//		git.pullReturnValue = ""
//		git.mentionsConflictReturnValue = true
//		git.statusReturnValue = ""
//		var resolver = MockInfoPlistResolver()
//		resolver.resultReturnValue = PlistConflictResult.resolved(dictionary: [:], url: URL(fileURLWithPath: "\(fileManager.currentDirectoryPath)/An-Info.plist"))
//		let helper = MockMergeHelper(resolver: resolver, fileManager: fileManager)
//		helper.resultsReturnValue = ([], [], [resolver.resultReturnValue!])
//		helper.commitMergeReturnValue = true
//		var sut = Pull(git: git, helper: helper)
//		sut.branchName = "anyBranch"
//		sut.verbose = true
//		sut.commit = true
//
//		// WHEN
//		XCTAssertNoThrow(try sut.run())
//
//		// THEN
//		XCTAssertTrue(helper.didCallCommitMerge)
//	}

}

