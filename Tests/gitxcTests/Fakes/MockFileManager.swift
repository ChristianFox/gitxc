
import Foundation

class MockFileManager: FileManager {
	
	override var currentDirectoryPath: String {
		_currentDirectoryPath ?? super.currentDirectoryPath
	}
	
	var _currentDirectoryPath: String?
	
//	override func findFiles(withSuffix suffix: String, in directoryURL: URL) throws -> [String] {
//		["SomeInfo.plist"]
//	}
}
