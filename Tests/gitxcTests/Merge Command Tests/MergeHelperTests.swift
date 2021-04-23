

import XCTest
@testable import GitXCLib

final class MergeHelperTests: XCTestCase {
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	
	// # Private/Fileprivate
	private var sut: MergeHelper!
	private var fileManager: MockFileManager!
	
	//=======================================
	// MARK: Setup / Teardown
	//=======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		fileManager = MockFileManager()
		fileManager._currentDirectoryPath = "/Volumes/iMacStorage/_Dev - Projects/Git Projects/MergeTestProjects/TestProject"
		sut = MergeHelper(plistResolver: InfoPlistResolver(), fileManager: fileManager)
	}
	
	override func tearDownWithError() throws {
		fileManager = nil
		sut = nil
		try super.tearDownWithError()
	}
	
	//=======================================
	// MARK: Tests
	//=======================================
	//------------------------------------
	// MARK: resolveConflicts(inInfoPlists:)
	//------------------------------------
	func testResolveConflicts_NoConflicts_ReturnsCorrectResults() throws {
		
		// GIVEN
		let plistText: String = FakeBuilder.stringWithoutConflict()
		let dirPath: String = NSTemporaryDirectory()
		let filePath: String = "tmp_source.plist"
		let plistURL: URL = URL(fileURLWithPath:"\(dirPath)/\(filePath)")
		try plistText.write(to: plistURL, atomically: false, encoding: .utf8)

		// WHEN
		let results = try sut.resolveConflicts(inInfoPlists: [filePath], rootDirectory: dirPath, verbose: true)
		
		// THEN
		XCTAssertEqual(1, results.noConflicts.count)
		XCTAssertEqual(0, results.manualResolutionNeeded.count)
		XCTAssertEqual(0, results.resolved.count)
	}
	
	func testResolveConflicts_TwoConflicts_ReturnsCorrectResults() throws {
		
		// GIVEN
		let plistText: String = FakeBuilder.stringWithTwoConflicts()
		let dirPath: String = NSTemporaryDirectory()
		let filePath: String = "tmp_source.plist"
		let plistURL: URL = URL(fileURLWithPath:"\(dirPath)/\(filePath)")
		try plistText.write(to: plistURL, atomically: false, encoding: .utf8)
		
		// WHEN
		let results = try sut.resolveConflicts(inInfoPlists: [filePath], rootDirectory: dirPath, verbose: true)
		
		// THEN
		XCTAssertEqual(0, results.noConflicts.count)
		XCTAssertEqual(1, results.manualResolutionNeeded.count)
		XCTAssertEqual(0, results.resolved.count)
	}

	func testResolveConflicts_BundleVersionConflict_ReturnsCorrectResults() throws {
		
		// GIVEN
		let plistText: String = FakeBuilder.stringWithConflict()
		let dirPath: String = NSTemporaryDirectory()
		let filePath: String = "tmp_source.plist"
		let plistURL: URL = URL(fileURLWithPath:"\(dirPath)/\(filePath)")
		try plistText.write(to: plistURL, atomically: false, encoding: .utf8)
		
		// WHEN
		let results = try sut.resolveConflicts(inInfoPlists: [filePath], rootDirectory: dirPath, verbose: true)
		
		// THEN
		XCTAssertEqual(0, results.noConflicts.count)
		XCTAssertEqual(0, results.manualResolutionNeeded.count)
		XCTAssertEqual(1, results.resolved.count)
	}
	
	func testResolveConflicts_OneOfEach_ReturnsCorrectResults() throws {
		
		// GIVEN
		let dirPath: String = NSTemporaryDirectory()
		try FakeBuilder.stringWithoutConflict().write(to: URL(fileURLWithPath:"\(dirPath)/noConflicts.plist"), atomically: false, encoding: .utf8)
		try FakeBuilder.stringWithTwoConflicts().write(to: URL(fileURLWithPath:"\(dirPath)/twoConflicts.plist"), atomically: false, encoding: .utf8)
		try FakeBuilder.stringWithConflict().write(to: URL(fileURLWithPath:"\(dirPath)/bundleVersionConflict.plist"), atomically: false, encoding: .utf8)
		let paths: [String] = ["noConflicts.plist", "twoConflicts.plist", "bundleVersionConflict.plist"]
		
		// WHEN
		let results = try sut.resolveConflicts(inInfoPlists: paths, rootDirectory: dirPath, verbose: true)
		
		// THEN
		XCTAssertEqual(1, results.noConflicts.count)
		XCTAssertEqual(1, results.manualResolutionNeeded.count)
		XCTAssertEqual(1, results.resolved.count)
	}

	//------------------------------------
	// MARK: commitMerge()
	//------------------------------------
	func testCommitMerge_CommitNotNeeded_ReturnsFalse() throws {
		
		// GIVEN
		var git: MockGit = MockGit(mockShell: MockShell())
		git.commitNeededReturnValue = false
		
		// WHEN
		let result = try sut.commitMerge(git: git, verbose: true)
		
		// THEN
		XCTAssertFalse(result)
	}

	func testCommitMerge_CommitNeededButUnsafe_ThrowsError() {
		
		// GIVEN
		var git: MockGit = MockGit(mockShell: MockShell())
		git.commitNeededReturnValue = true
		git.containsErrorsReturnValue = true
		git.statusReturnValue = """
			error: Merging is not possible because you have unmerged files.
			hint: Fix them up in the work tree, and then use 'git add/rm <file>'
			hint: as appropriate to mark resolution and make a commit.
			fatal: Exiting because of an unresolved conflict.
			"""
		
		// WHEN, THEN
		XCTAssertThrowsError(try sut.commitMerge(git: git, verbose: true))
	}
	
//	func testCommitMerge_CommitNeededButNoUnmergedPaths_ReturnsFalse() throws {
//
//		// GIVEN
//		var git: MockGit = MockGit(mockShell: MockShell())
//		git.commitNeededReturnValue = true
//		git.containsErrorsReturnValue = true
//		git.statusReturnValue = "git status does not contain any unmerged path info"
//
//		// WHEN
//		let result = try sut.commitMerge(git: git)
//
//		// THEN
//		XCTAssertFalse(result)
//	}
	

	func testCommitMerge_AllValid_ReturnsTrue() throws {
		
		// GIVEN
		var git: MockGit = MockGit(mockShell: MockShell())
		git.commitNeededReturnValue = true
		git.containsErrorsReturnValue = false
		git.statusReturnValue = """
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
		git.addAllReturnValue = "git.addAll() called during unit testing"
		git.commitReturnValue = "git.commit() called during unit testing"

		// WHEN
		let result = try sut.commitMerge(git: git, verbose: true)
		
		// THEN
		XCTAssertTrue(result)
	}

	//------------------------------------
	// MARK: postMergeProcessing()
	//------------------------------------
	func testPostMergeProcessing_NoConflict_CompletesWithoutThrowing() throws {
		
		// GIVEN
		var git: MockGit = MockGit(mockShell: MockShell())
		git.mentionsConflictReturnValue = false
		let mergeResult: String = "It doesn't matter what is here for this test"
		let shouldCommit: Bool = false // Should return before eval anyway

		// WHEN, THEN
		XCTAssertNoThrow(try sut.postMergeProcessing(mergeResult: mergeResult, git: git, shouldCommit: shouldCommit, verbose: true))
	}
	
	func testPostMergeProcessing_GitHasConflicts_PlistsNoConflicts_CompletesWithoutThrowing() throws {
		
		// GIVEN
		let plistResolver: MockInfoPlistResolver = MockInfoPlistResolver(resultReturnValue: .noConflict)
		let sut = MergeHelper(plistResolver: plistResolver, fileManager: fileManager)
		var git: MockGit = MockGit(mockShell: MockShell())
		git.mentionsConflictReturnValue = true
		let mergeResult: String = "It doesn't matter what is here for this test"
		let shouldCommit: Bool = false // Should return before eval anyway

		// WHEN, THEN
		XCTAssertNoThrow(try sut.postMergeProcessing(mergeResult: mergeResult, git: git, shouldCommit: shouldCommit, verbose: true))
	}

}

