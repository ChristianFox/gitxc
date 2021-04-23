
import Foundation

public protocol ShellInterface {
	
	func perform(_ command: String) -> String
}

/// Run Shell commands
public struct Shell: ShellInterface {
	
	public func perform(_ command: String) -> String {
		
		let task = Process()
		let pipe = Pipe()
		
		task.standardOutput = pipe
		task.arguments = ["-c", command]
		task.launchPath = "/bin/zsh"
		task.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!
		task.waitUntilExit()
		return output
	}


//	@discardableResult
//	func shell(_ args: String...) -> Int32 {
//		print("Did start")
//		let task = Process()
//		task.launchPath = "/usr/bin/env"
//		task.arguments = args
//		task.launch()
//		task.waitUntilExit()
//		print("will end")
//		return task.terminationStatus
//	}
//
//	func shell(launchPath: String, arguments: [String] = []) -> (String? , Int32) {
//		let task = Process()
//		task.launchPath = launchPath
//		task.arguments = arguments
//
//		let pipe = Pipe()
//		task.standardOutput = pipe
//		task.standardError = pipe
//		task.launch()
//		let data = pipe.fileHandleForReading.readDataToEndOfFile()
//		let output = String(data: data, encoding: .utf8)
//		task.waitUntilExit()
//		return (output, task.terminationStatus)
//	}

}
