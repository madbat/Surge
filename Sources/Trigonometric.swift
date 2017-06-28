// Trigonometric.swift
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
    /// Sine-Cosine
    public func sincos() -> (sin: [Element], cos: [Element]) {
        var sin = [Element](repeating: 0.0, count: count)
        var cos = [Element](repeating: 0.0, count: count)
        vvsincosf(&sin, &cos, self, [Int32(count)])

        return (sin, cos)
    }

    /// Sine
    public func sin() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvsinf(&results, self, [Int32(count)])

        return results
    }

    /// Cosine
    public func cos() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvcosf(&results, self, [Int32(count)])

        return results
    }

    /// Tangent
    public func tan() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvtanf(&results, self, [Int32(count)])

        return results
    }

    /// Arcsine
    public func asin() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvasinf(&results, self, [Int32(count)])

        return results
    }

    /// Arccosine
    public func acos() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvacosf(&results, self, [Int32(count)])

        return results
    }

    /// Arctangent
    public func atan() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvatanf(&results, self, [Int32(count)])

        return results
    }

    /// Radians to Degrees
    func rad2deg() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        let divisor = [Element](repeating: Element(.pi / 180.0), count: count)
        vvdivf(&results, self, divisor, [Int32(count)])

        return results
    }

    /// Degrees to Radians
    func deg2rad() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        let divisor = [Element](repeating: Element(180.0 / .pi), count: count)
        vvdivf(&results, self, divisor, [Int32(count)])

        return results
    }
}


extension Array where Element == Double {
    /// Sine-Cosine
    public func sincos() -> (sin: [Element], cos: [Element]) {
        var sin = [Element](repeating: 0.0, count: count)
        var cos = [Element](repeating: 0.0, count: count)
        vvsincos(&sin, &cos, self, [Int32(count)])

        return (sin, cos)
    }

    /// Sine
    public func sin() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvsin(&results, self, [Int32(count)])

        return results
    }

    /// Cosine
    public func cos() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvcos(&results, self, [Int32(count)])

        return results
    }

    /// Tangent
    public func tan() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvtan(&results, self, [Int32(count)])

        return results
    }

    /// Arcsine
    public func asin() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvasin(&results, self, [Int32(count)])

        return results
    }

    /// Arccosine
    public func acos() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvacos(&results, self, [Int32(count)])

        return results
    }

    /// Arctangent
    public func atan() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvatan(&results, self, [Int32(count)])

        return results
    }

    /// Radians to Degrees
    func rad2deg() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        let divisor = [Element](repeating: Element(.pi / 180.0), count: count)
        vvdiv(&results, self, divisor, [Int32(count)])

        return results
    }

    /// Degrees to Radians
    func deg2rad() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        let divisor = [Element](repeating: Element(180.0 / .pi), count: count)
        vvdiv(&results, self, divisor, [Int32(count)])

        return results
    }
}
