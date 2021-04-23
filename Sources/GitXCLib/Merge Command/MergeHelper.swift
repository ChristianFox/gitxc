
import Foundation

public typealias PlistConflictResults = (noConflicts: [PlistConflictResult], manualResolutionNeeded: [PlistConflictResult], resolved: [PlistConflictResult])


public protocol MergeHelperInterface {

	func postMergeProcessing(mergeResult: String, git: GitInterface, shouldCommit: Bool, verbose: Bool) throws
	
	func resolveConflicts(inInfoPlists paths: [String], rootDirectory: String, verbose: Bool) throws -> PlistConflictResults
	
	func commitMerge(git: GitInterface, verbose: Bool) throws -> Bool
}

public struct MergeHelper: MergeHelperInterface {
	
	/// Tool for resolving conflicts in Info.plist files
	public var plistResolver: InfoPlistResolverInterface
	
	/// FileManager - can be replaced during unit tests
	public var fileManager: FileManager
	
	public func postMergeProcessing(mergeResult: String, git: GitInterface, shouldCommit: Bool, verbose: Bool) throws {
		
		print(#function)
		guard !git.containsErrors(mergeResult) else {
			throw RuntimeError(mergeResult)
		}
		print("no errors contained in '\(mergeResult)'")
		// # Return if no conflicts
		if !git.mentionsConflict(mergeResult) {
			if verbose {
				print("!! gitxc did finish. Merge/Pull completed successfully, no conflict resolution needed.")
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
			print("!!! gitxc did finish. No conflicts found in Info.plists. Manual resolution in non Info.plist files may be necessary.")
			return
		}
		
		// # Commit if necessary
		if plistResults.manualResolutionNeeded.count == 0 && plistResults.resolved.count >= 1 {
			
			if shouldCommit {
				if try commitMerge(git: git, verbose: verbose) {
					print("!!! gitxc did finish. All conflicts resolved and merge completed and committed.")
					return
				} else {
					print("gitxc was unable to commit.")
				}
			}
		}
		
		print("!!! gitxc did finish. Conflict resolution did occur. Commit is necessary, Manual resolution in non Info.plist files may be necessary.")

	}
	
	public func resolveConflicts(inInfoPlists paths: [String], rootDirectory: String, verbose: Bool) throws -> PlistConflictResults {
		
		var noConflict: [PlistConflictResult] = []
		var resolutionNeeded: [PlistConflictResult] = []
		var resolved: [PlistConflictResult] = []
		try paths.forEach { (plistPath) in
			
			let fullPath: String = "\(rootDirectory)/\(plistPath)"
			let text: String = try String(contentsOfFile: fullPath)

			let result: PlistConflictResult = try plistResolver.resolveBundleVersionConflict(text)
			switch result {
			case .noConflict:
				if verbose {
					print("No conflict found in file: \(plistPath)")
				}
				noConflict.append(result)
			case .manualResolutionNeeded:
				if verbose {
					print("Manual Resolution Needed in file: \(plistPath)")
				}
				resolutionNeeded.append(result)
			case .resolved(_, let url):
				if verbose {
					print("Conflict resolved in file: \(plistPath),")
				}
				try fileManager.removeItem(atPath: fullPath)
				try fileManager.copyItem(atPath: url.path, toPath: fullPath)
				resolved.append(result)
			}
		}
		
		return (noConflict, resolutionNeeded, resolved)
	}
	
	public func commitMerge(git: GitInterface, verbose: Bool) throws -> Bool {
		
		guard git.commitNeeded() else {
			if verbose {
				print("Commit not needed")
			}
			return false
		}
		
		guard !git.statusContainsErrors() else {
			if verbose {
				print("Commit not possible due to errors or unresolved conflicts")
			}
			let status: String = git.status()
			throw RuntimeError(status)
		}
		
		if let unmergedPaths: [String] = git.unmergedPaths(fromStatus: git.status()) {

			let nonInfoPlists: [String] = unmergedPaths.filter{ !$0.hasSuffix("Info.plist") }
			if verbose {
				print("all unmerged paths:\n\t\(unmergedPaths.debugDescription)")
			}
			if !nonInfoPlists.isEmpty {
				if verbose {
					print("gitxc can not commit because there are unmerged paths that are not suffixed with Info.plist:\n\t \(nonInfoPlists.debugDescription)")
				}
				return false
			}
		}
		
		let addResult: String = git.addAll()
		let commitResult: String = git.commit("Merge committed using gitxc")
		if verbose {
			print("Did run 'git add .' & received response: \(addResult)")
			print("Did run 'git commit' & received response: \(commitResult)")
		}
		return true
	}
}
