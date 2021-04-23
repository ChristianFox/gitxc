
import Foundation
import ArgumentParser

/// Pulls a branch changes into the current branch and checks for and resolves any CFBundleVersion conflicts in all Info.plist files by taking the highest value
public struct Pull: ParsableCommand {
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	public static let configuration = CommandConfiguration(
		abstract: "Pulls a branch changes into the current branch and checks for and resolves any CFBundleVersion conflicts in all Info.plist files by taking the highest value"
	)

	/// Tool for interacting with Git
	public static var git: GitInterface!
	
	/// Helper
	public static var helper: MergeHelperInterface!
	
	/// The name of the branch to merge into the current branch
	@Argument(help: "The name of the branch to pull into the current branch")
	public var branchName: String?
	
	/// If enabled prints additional information during the merge process
	@Flag(name: [.short, .long], help: "If enabled prints additional information during the pull process")
	public var verbose: Bool = false
	
	/// If enabled will commit after resolving plist conflicts if that is possible, will not attempt to commit if unresolved conflicts remain
	@Flag(name: [.short, .long], help: "If enabled will commit after resolving plist conflicts if that is possible, will not attempt to commit if unresolved conflicts remain")
	public var commit: Bool = false

	// # Private/Fileprivate
	
	//=======================================
	// MARK: Public Methods
	//=======================================
	//------------------------------------
	// MARK: Init
	//------------------------------------
	public init() {
		Self.git = Git(shell: Shell())
		Self.helper = MergeHelper(plistResolver: InfoPlistResolver(), fileManager: FileManager.default)
	}
	
	public init(git: GitInterface, helper: MergeHelperInterface) {
		Self.git = git
		Self.helper = helper
	}

	//------------------------------------
	// MARK: run
	//------------------------------------
	public func run() throws {

		if verbose {
			print("\n###### gitxc pull ######\n")
		}

		// # Perform Pull
		let result: String = Self.git.pull(branchName)
		print("Pull Result: \(result). Status: \(Self.git.status())")

		// # Resolve conflicts and commit if required
		try Self.helper.postMergeProcessing(mergeResult: result, git: Self.git, shouldCommit: commit, verbose: verbose)
	}
	
	//=======================================
	// MARK: Private Methods
	//=======================================
	
}
