// Auxilliary.swift
//
// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Accelerate

extension Array where Element == Float {
    /// Absolute Value
    public func abs() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvfabsf(&results, self, [Int32(count)])

        return results
    }

    /// Ceiling
    public func ceil() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvceilf(&results, self, [Int32(count)])

        return results
    }

    /// Clip
    public func clip(low: Element, high: Element) -> [Element] {
        var results = [Element](repeating: 0.0, count: count), y = low, z = high
        vDSP_vclip(self, 1, &y, &z, &results, 1, vDSP_Length(count))

        return results
    }

    /// Copy Sign
    public func copysign(_ sign: [Element], magnitude: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: sign.count)
        vvcopysignf(&results, magnitude, sign, [Int32(sign.count)])

        return results
    }

    /// Floor
    public func floor() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvfloorf(&results, self, [Int32(count)])

        return results
    }

    /// Negate
    public func neg() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vDSP_vneg(self, 1, &results, 1, vDSP_Length(count))

        return results
    }

    /// Reciprocal
    public func rec() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvrecf(&results, self, [Int32(count)])

        return results
    }

    /// Round
    public func round() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvnintf(&results, self, [Int32(count)])

        return results
    }

    /// Threshold
    public func threshold(low: Element) -> [Element] {
        var results = [Element](repeating: 0.0, count: count), y = low
        vDSP_vthr(self, 1, &y, &results, 1, vDSP_Length(count))

        return results
    }

    /// Truncate
    public func trunc() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvintf(&results, self, [Int32(count)])

        return results
    }
}


extension Array where Element == Double {
    /// Absolute Value
    public func abs() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvfabs(&results, self, [Int32(count)])

        return results
    }

    /// Ceiling
    public func ceil() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvceil(&results, self, [Int32(count)])

        return results
    }

    /// Clip
    public func clip(low: Element, high: Element) -> [Element] {
        var results = [Element](repeating: 0.0, count: count), y = low, z = high
        vDSP_vclipD(self, 1, &y, &z, &results, 1, vDSP_Length(count))

        return results
    }

    /// Copy Sign
    public func copysign(_ magnitude: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvcopysign(&results, magnitude, self, [Int32(count)])

        return results
    }

    /// Floor
    public func floor() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvfloor(&results, self, [Int32(count)])

        return results
    }

    /// Negate
    public func neg() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vDSP_vnegD(self, 1, &results, 1, vDSP_Length(count))

        return results
    }

    /// Reciprocal
    public func rec() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvrec(&results, self, [Int32(count)])

        return results
    }

    /// Round
    public func round() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvnint(&results, self, [Int32(count)])

        return results
    }

    /// Threshold
    public func threshold(low: Element) -> [Element] {
        var results = [Element](repeating: 0.0, count: count), y = low
        vDSP_vthrD(self, 1, &y, &results, 1, vDSP_Length(count))

        return results
    }

    /// Truncate
    public func trunc() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvint(&results, self, [Int32(count)])

        return results
    }
}
