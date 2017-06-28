// Hyperbolic.swift
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
    /// Hyperbolic Sine
    public func sinh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvsinhf(&results, self, [Int32(count)])

        return results
    }

    /// Hyperbolic Cosine
    public func cosh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvcoshf(&results, self, [Int32(count)])

        return results
    }

    /// Hyperbolic Tangent
    public func tanh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvtanhf(&results, self, [Int32(count)])

        return results
    }

    /// Inverse Hyperbolic Sine
    public func asinh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvasinhf(&results, self, [Int32(count)])

        return results
    }

    /// Inverse Hyperbolic Cosine
    public func acosh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvacoshf(&results, self, [Int32(count)])

        return results
    }

    /// Inverse Hyperbolic Tangent
    public func atanh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvatanhf(&results, self, [Int32(count)])

        return results
    }
}

extension Array where Element == Double {
    /// Hyperbolic Sine
    public func sinh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvsinh(&results, self, [Int32(count)])

        return results
    }

    /// Hyperbolic Cosine
    public func cosh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvcosh(&results, self, [Int32(count)])

        return results
    }

    /// Hyperbolic Tangent
    public func tanh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvtanh(&results, self, [Int32(count)])

        return results
    }

    /// Inverse Hyperbolic Sine
    public func asinh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvasinh(&results, self, [Int32(count)])

        return results
    }

    /// Inverse Hyperbolic Cosine
    public func acosh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvacosh(&results, self, [Int32(count)])

        return results
    }

    /// Inverse Hyperbolic Tangent
    public func atanh() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvatanh(&results, self, [Int32(count)])

        return results
    }
}
