/*
 StrictString.ScalarView.Index.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension String.UnicodeScalarView.Index {

    // MARK: - Conversions

    /// Returns the position in the given view of clusters that corresponds exactly to this index.
    public func samePosition(in clusters: StrictString.ClusterView) -> StrictString.ClusterView.Index? {
        return samePosition(in: String(StrictString(clusters)))
    }

    /// Returns the position of the cluster that contains this index.
    public func cluster(in clusters: StrictString.ClusterView) -> StrictString.ClusterView.Index {
        return cluster(in: String(StrictString(clusters)).clusters)
    }

    /// Returns the position in the given view of lines that corresponds exactly to this index.
    public func samePosition(in lines: LineView<StrictString>) -> LineView<StrictString>.Index? {
        let scalars = StrictString(lines).scalars
        if self == scalars.startIndex {
            return lines.startIndex
        } else if self == scalars.endIndex {
            return lines.endIndex
        } else {
            var result = lines.startIndex
            for match in scalars.matches(for: LineView<StrictString>.newlinePattern) {

                if self == match.range.upperBound {
                    return result + 1
                } else if self > match.range.upperBound {
                    result += 1
                } else {
                    break
                }
            }
            return nil
        }
    }

    /// Returns the position of the line that contains this index.
    public func line(in lines: LineView<StrictString>) -> LineView<StrictString>.Index {
        if self == StrictString(lines).scalars.endIndex {
            return lines.endIndex
        } else {
            var result = lines.startIndex
            for match in StrictString(lines).matches(for: LineView<StrictString>.newlinePattern) {
                if self ≥ match.range.upperBound {
                    result += 1
                } else {
                    break
                }
            }
            return result
        }
    }
}
