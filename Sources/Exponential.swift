// Exponential.swift
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

// MARK: - Array of Floats

extension Array where Element == Float {
    /// Exponentiation
    public func exp() -> [Element] {
        var results = self
        vvexpf(&results, self, [Int32(count)])

        return results
    }

    /// Square Exponentiation
    public func exp2() -> [Element] {
        var results = self
        vvexp2f(&results, self, [Int32(count)])

        return results
    }

    /// Natural Logarithm
    public func log() -> [Element] {
        var results = self
        vvlogf(&results, self, [Int32(count)])

        return results
    }

    /// Base-2 Logarithm
    public func log2() -> [Element] {
        var results = self
        vvlog2f(&results, self, [Int32(count)])

        return results
    }

    /// Base-10 Logarithm
    public func log10() -> [Element] {
        var results = self
        vvlog10f(&results, self, [Int32(count)])

        return results
    }

    /// Logarithmic Exponentiation
    public func logb() -> [Element] {
        var results = self
        vvlogbf(&results, self, [Int32(count)])

        return results
    }
}


// MARK: - Array of Doubles

extension Array where Element == Double {
    /// Exponentiation
    public func exp() -> [Element] {
        var results = self
        vvexp(&results, self, [Int32(count)])

        return results
    }

    /// Square Exponentiation
    public func exp2() -> [Element] {
        var results = self
        vvexp2(&results, self, [Int32(count)])

        return results
    }

    /// Natural Logarithm
    public func log() -> [Element] {
        var results = self
        vvlog(&results, self, [Int32(count)])

        return results
    }

    /// Base-2 Logarithm
    public func log2() -> [Element] {
        var results = self
        vvlog2(&results, self, [Int32(count)])

        return results
    }

    /// Base-10 Logarithm
    public func log10() -> [Element] {
        var results = self
        vvlog10(&results, self, [Int32(count)])

        return results
    }

    /// Logarithmic Exponentiation
    public func logb() -> [Element] {
        var results = self
        vvlogb(&results, self, [Int32(count)])

        return results
    }
}
