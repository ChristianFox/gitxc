
import Foundation
@testable import GitXCLib

struct MockShell: ShellInterface {
	
	func perform(_ command: String) -> String {
		print("MockShell perform(_ command: ) Command = \(command)")
		return command
	}
}
