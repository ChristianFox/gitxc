
import Foundation
@testable import GitXCLib

final class MockMergeHelper: MergeHelperInterface {
	
	//------------------------------------
	// MARK: Control & Response
	//------------------------------------
	var resultsReturnValue: PlistConflictResults?
	var didCallCommitMerge: Bool = false
	var commitMergeReturnValue: Bool?
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	let resolver: InfoPlistResolverInterface
	let fileManager: FileManager
	
	//------------------------------------
	// MARK: Init
	//------------------------------------
	init(resolver: InfoPlistResolverInterface, fileManager: FileManager) {
		self.resolver = resolver
		self.fileManager = fileManager
	}

	//------------------------------------
	// MARK: MergeHelperInterface
	//------------------------------------
	func postMergeProcessing(mergeResult: String, git: GitInterface, shouldCommit: Bool, verbose: Bool) throws {
		
		// # Return if no conflicts
		if !git.mentionsConflict(mergeResult) {
			if verbose {
				print("!! Bastard did finish. Merge/Pull completed successfully, no conflict resolution needed.")
			}
			return
		} else {
			if verbose {
				print("Conflicts found. Will attempt to resolve Info.plist CFBundleVersion conflicts.")
			}
		}

		// # Find Info.plist files
		let currentDirectory: String = fileManager.currentDirectoryPath
		let infoPlists: [String] = try fileManager.findFiles(withSuffix: "Info.plist", in: URL(fileURLWithPath: currentDirectory))
		
		// # Resolve conflicts
		let plistResults = try resolveConflicts(inInfoPlists: infoPlists, rootDirectory: currentDirectory, verbose: verbose)
		
		if verbose {
			print("\n\(infoPlists.count) Info.plist files checked.\n\(plistResults.noConflicts.count) had no conflicts.\n\(plistResults.manualResolutionNeeded.count) need manual resolution.\n\(plistResults.resolved.count) files fully resolvd")
		}
		
		if plistResults.noConflicts.count == infoPlists.count {
			print("!!! Bastard did finish. No conflicts found in Info.plists. Manual resolution in non Info.plist files may be necessary.")
			return
		}
		
		// # Commit if necessary
		if plistResults.manualResolutionNeeded.count == 0 && plistResults.resolved.count >= 1 {
			
			if shouldCommit {
				if try commitMerge(git: git, verbose: verbose) {
					print("!!! Bastard did finish. All conflicts resolved and merge completed and committed.")
					return
				} else {
					print("Bastard was unable to commit.")
				}
			}
		}
		
		print("!!! Bastard did finish. Conflict resolution did occur. Commit is necessary, Manual resolution in non Info.plist files may be necessary.")
	}
	
	func resolveConflicts(inInfoPlists paths: [String], rootDirectory: String, verbose: Bool) throws -> PlistConflictResults {
		resultsReturnValue!
	}
	
	func commitMerge(git: GitInterface, verbose: Bool) throws -> Bool {
		didCallCommitMerge = true
		return commitMergeReturnValue! 
	}
}
