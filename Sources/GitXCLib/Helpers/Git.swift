
import Foundation

public protocol GitInterface {
	
	//------------------------------------
	// MARK: Commands
	//------------------------------------
	/// Perform `git status`
	func status() -> String
	
	/// Perform `git add .`
	func addAll() -> String
	
	/// Perform `git commit -m "\(message)"`
	func commit(_ message: String?) -> String
	
	/// Perform `git merge \(branchName)`
	func merge(_ branchName: String) -> String

	/// Perform `git pull \(branchName)`
	func pull(_ branchName: String?) -> String

	//------------------------------------
	// MARK: Info
	//------------------------------------
	func currentBranch() -> String
	
	func commitNeeded() -> Bool
	
	func statusContainsErrors() -> Bool

	func containsErrors(_ text: String) -> Bool

	//------------------------------------
	// MARK: Response Parsing
	//------------------------------------
	/// Does the `statusText` contain `working tree clean`
	func statusIsClean(_ statusText: String) -> Bool
	
	/// Does the `resultText` from git contain any mention of a "conflict"
	func mentionsConflict(_ resultText: String) -> Bool
	
	/// When given the result of `git status` will return an array of unmerged paths or nil if there are none
	func unmergedPaths(fromStatus statusText: String) -> [String]?
}

public struct Git: GitInterface {
	
	public let shell: ShellInterface
	
	//------------------------------------
	// MARK: Commands
	//------------------------------------
	public func status() -> String {
		shell.perform("git status")
	}
	
	public func addAll() -> String {
		shell.perform("git add .")
	}
	
	public func commit(_ message: String? = nil) -> String {
		shell.perform("git commit -m '\(message ?? "Committed by Bastard Tool")'")
	}
	
	public func merge(_ branchName: String) -> String {
		shell.perform("git merge \(branchName)")
	}

	public func pull(_ branchName: String?) -> String {
		if let branchName = branchName {
			return shell.perform("git pull origin \(branchName)")
		} else {
			return shell.perform("git pull")
		}
	}

	//------------------------------------
	// MARK: Info
	//------------------------------------
	public func currentBranch() -> String {
		shell.perform("git branch --show-current")
	}
	
	public func commitNeeded() -> Bool {
		!statusIsClean(status())
	}
	
	public func statusContainsErrors() -> Bool {
		let status: String = self.status()
		return containsErrors(status)
	}

	public func containsErrors(_ text: String) -> Bool {
		return text.contains("error") || text.contains("fatal")
	}

	//------------------------------------
	// MARK: Response Parsing
	//------------------------------------
	public func statusIsClean(_ statusText: String) -> Bool {
		statusText.contains("working tree clean")
	}

	public func mentionsConflict(_ resultText: String) -> Bool {
		resultText.lowercased().contains("conflict")
	}
	
	public func unmergedPaths(fromStatus statusText: String) -> [String]? {
		
		guard statusText.contains("Unmerged paths") else {
			return nil
		}
		
		let bothModified: String = "both modified:"
		var statusComps: [String] = statusText.components(separatedBy: bothModified)
		statusComps.removeFirst()
		
		if let last: String = statusComps.last,
		   let cleanedLast: String = last.components(separatedBy: "\n").first {
			statusComps.removeLast()
			statusComps.append(cleanedLast)
		}
		
		statusComps = statusComps.map{ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}

		return statusComps
	}

}




/*

Git Output Examples:

## Conflicts

Auto-merging Watch/WatchDev-Info.plist
CONFLICT (content): Merge conflict in Watch/WatchDev-Info.plist
Auto-merging Watch/Watch-Info.plist
CONFLICT (content): Merge conflict in Watch/Watch-Info.plist
Auto-merging Watch Extension/Supporting Files/WatchExtension-Info.plist
CONFLICT (content): Merge conflict in Watch Extension/Supporting Files/WatchExtension-Info.plist
Auto-merging Watch Extension/Supporting Files/WatchDevExtension-Info.plist
CONFLICT (content): Merge conflict in Watch Extension/Supporting Files/WatchDevExtension-Info.plist
Auto-merging NotificationContent/NoteContent-Info.plist
CONFLICT (content): Merge conflict in NotificationContent/NoteContent-Info.plist
Auto-merging MoSProd/Supporting Files/TargetName-Info.plist
CONFLICT (content): Merge conflict in TargetName/Supporting Files/TargetName-Info.plist
Auto-merging MoSProd/Supporting Files/TargetName-Info.plist
CONFLICT (content): Merge conflict in TargetName/Supporting Files/TargetName-Info.plist
Automatic merge failed; fix conflicts and then commit the result.



## Unresolved Conflicts

error: Merging is not possible because you have unmerged files.
hint: Fix them up in the work tree, and then use 'git add/rm <file>'
hint: as appropriate to mark resolution and make a commit.
fatal: Exiting because of an unresolved conflict.

Merge completed successfully


## Calling `git status` when nothing to commit

On branch mergeTests/branchOne
nothing to commit, working tree clean


## Calling `git status` when uncommitted merge

On branch mergeTests/branchOne
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   TargetName/Supporting Files/TargetName-Info.plist
	both modified:   NotificationContent/NoteContent-Info.plist
	both modified:   Watch Extension/Supporting Files/WatchExtension-Info.plist
	both modified:   Watch/Watch-Info.plist

no changes added to commit (use "git add" and/or "git commit -a")

## Merge not necessary

Already up to date.

Merge completed successfully


## Branch not recognised

fatal: 'branchA' does not appear to be a git repository
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

*/
