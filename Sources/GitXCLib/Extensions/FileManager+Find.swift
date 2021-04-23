
import Foundation

public enum FileFinderError: Error {
	case urlNeedsToBeMoreSpecific
	case searchSuffixIsEmpty
}

extension FileManager {
	
	/// Finds all files with a matching `suffix` (including file extension) in the given `directoryURL`
	/// - Parameters:
	///   - suffix: The suffix search string
	///   - directoryURL: A file URL for the directory to search
	/// - Throws: FileFinderError
	/// - Returns: An array of file names including file extension.
	public func findFiles(withSuffix suffix: String, in directoryURL: URL) throws -> [String] {
		
		var isDirectory: ObjCBool = false
		guard !directoryURL.path.isEmpty, directoryURL.pathComponents.count > 2 else {
			throw FileFinderError.urlNeedsToBeMoreSpecific
		}
		guard !suffix.isEmpty else {
			throw FileFinderError.searchSuffixIsEmpty
		}
		guard fileExists(atPath: directoryURL.path, isDirectory: &isDirectory),
			  isDirectory.boolValue else {
			return []
		}
		
		guard let enumerator: FileManager.DirectoryEnumerator = enumerator(atPath: directoryURL.path),
			  let allFiles: [String] = enumerator.allObjects as? [String] else {
			return []
		}
		
//        print("allFiles: \(allFiles)")
		let matchingFiles: [String] = allFiles.filter{ $0.hasSuffix(suffix)}
		return matchingFiles
	}

}
