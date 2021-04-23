
import Foundation
@testable import GitXCLib

struct MockGit: GitInterface {
	
	//------------------------------------
	// MARK: Control & Reponses
	//------------------------------------
	var statusReturnValue: String?
	var addAllReturnValue: String?
	var commitReturnValue: String?
	var mergeReturnValue: String?
	var pullReturnValue: String?
	var currentBranchReturnValue: String?
	var commitNeededReturnValue: Bool?
	var containsErrorsReturnValue: Bool?
	var statusIsCleanReturnValue: Bool?
	var mentionsConflictReturnValue: Bool?
	var unmergedPathsReturnValue: [String]?
	
	//------------------------------------
	// MARK: Properties
	//------------------------------------
	let shell: MockShell
	
	//------------------------------------
	// MARK: Init
	//------------------------------------
	init(mockShell: MockShell) {
		shell = mockShell
	}
	
	//------------------------------------
	// MARK: GitInterface
	//------------------------------------
	//------------------------------------
	// MARK: Commands
	//------------------------------------
	func status() -> String {
		statusReturnValue!
	}
	
	func addAll() -> String {
		addAllReturnValue!
	}
	
	func commit(_ message: String?) -> String {
		commitReturnValue!
	}
	
	func merge(_ branchName: String) -> String {
		mergeReturnValue!
	}
	
	func pull(_ branchName: String?) -> String {
		pullReturnValue!
	}
	
	//------------------------------------
	// MARK: Info
	//------------------------------------
	func currentBranch() -> String {
		currentBranchReturnValue!
	}
	
	func commitNeeded() -> Bool {
		commitNeededReturnValue!
	}
	
	func statusContainsErrors() -> Bool {
		containsErrorsReturnValue ?? false
	}
	
	func containsErrors(_ text: String) -> Bool {
		containsErrorsReturnValue ?? false
	}

	//------------------------------------
	// MARK: Response Parsing
	//------------------------------------
	func statusIsClean(_ statusText: String) -> Bool {
		statusIsCleanReturnValue!
	}

	func mentionsConflict(_ resultText: String) -> Bool {
		mentionsConflictReturnValue!
	}
	
	func unmergedPaths(fromStatus statusText: String) -> [String]? {
		if let unmergedPathsReturnValue = unmergedPathsReturnValue {
			return unmergedPathsReturnValue
		}
		
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
