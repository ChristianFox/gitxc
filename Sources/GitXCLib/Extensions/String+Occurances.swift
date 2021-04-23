
import Foundation

public extension String {
	
	/// Determine the number of occurances of the given `substring`
	/// - Parameter substring: The search string
	/// - Returns: The number of occurances
	func occurances(of substring: String) -> Int {
		
		var count: Int = 0
		var mutString: String = self
		while mutString.contains(substring) {
			
			if let range: Range = mutString.range(of: substring) {

				mutString = String(mutString.suffix(from: range.upperBound))
				count += 1
			}
		}
		return count
	}
}
