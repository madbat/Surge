// Arithmetic.swift
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

infix operator •

extension Array where Element == Float {
    /// Sum
    public func sum() -> Element {
        var result: Element = 0.0
        vDSP_sve(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Sum of Absolute Values
    public func asum() -> Element {
        return cblas_sasum(Int32(count), self, 1)
    }

    /// Maximum
    public func max() -> Element {
        var result: Element = 0.0
        vDSP_maxv(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Minimum
    public func min() -> Element {
        var result: Element = 0.0
        vDSP_minv(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Mean
    public func mean() -> Element {
        var result: Element = 0.0
        vDSP_meanv(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Mean Magnitude
    public func meamg() -> Element {
        var result: Element = 0.0
        vDSP_meamgv(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Mean Square Value
    public func measq() -> Element {
        var result: Element = 0.0
        vDSP_measqv(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Square Root
    public func sqrt() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvsqrtf(&results, self, [Int32(count)])

        return results
    }

    /// Addition
    public static func add(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](y)
        cblas_saxpy(Int32(x.count), 1.0, x, 1, &results, 1)

        return results
    }

    /// Subtraction
    public static func sub(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](y)
        catlas_saxpby(Int32(x.count), 1.0, x, 1, -1, &results, 1)

        return results
    }

    /// Multiply
    public static func mul(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vDSP_vmul(x, 1, y, 1, &results, 1, vDSP_Length(x.count))

        return results
    }

    /// Divide
    public static func div(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vvdivf(&results, x, y, [Int32(x.count)])

        return results
    }

    /// Modulo
    public static func mod(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vvfmodf(&results, x, y, [Int32(x.count)])

        return results
    }

    /// Remainder
    public static func remainder(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vvremainderf(&results, x, y, [Int32(x.count)])

        return results
    }

    /// Dot Product
    public static func dot(_ x: [Element], _ y: [Element]) -> Element {
        precondition(x.count == y.count, "Vectors must have equal count")

        var result: Element = 0.0
        vDSP_dotpr(x, 1, y, 1, &result, vDSP_Length(x.count))

        return result
    }

    /// Distance
    public static func dist(_ x: [Element], _ y: [Element]) -> Element {
        precondition(x.count == y.count, "Vectors must have equal count")
        let sub = x - y
        var squared = [Element](repeating: 0.0, count: x.count)
        vDSP_vsq(sub, 1, &squared, 1, vDSP_Length(x.count))

        return squared.sum().squareRoot()
    }

    public static func + (lhs: [Element], rhs: [Element]) -> [Element] {
        return add(lhs, rhs)
    }

    public static func + (lhs: [Element], rhs: Element) -> [Element] {
        return add(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func - (lhs: [Element], rhs: [Element]) -> [Element] {
        return sub(lhs, rhs)
    }

    public static func - (lhs: [Element], rhs: Element) -> [Element] {
        return sub(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func / (lhs: [Element], rhs: [Element]) -> [Element] {
        return div(lhs, rhs)
    }

    public static func / (lhs: [Element], rhs: Element) -> [Element] {
        return div(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func * (lhs: [Element], rhs: [Element]) -> [Element] {
        return mul(lhs, rhs)
    }

    public static func * (lhs: [Element], rhs: Element) -> [Element] {
        return mul(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func % (lhs: [Element], rhs: [Element]) -> [Element] {
        return mod(lhs, rhs)
    }

    public static func % (lhs: [Element], rhs: Element) -> [Element] {
        return mod(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func • (lhs: [Element], rhs: [Element]) -> Element {
        return dot(lhs, rhs)
    }
}

extension Array where Element == Double {
    /// Sum
    public func sum() -> Element {
        var result: Element = 0.0
        vDSP_sveD(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Sum of Absolute Values
    public func asum() -> Element {
        return cblas_dasum(Int32(count), self, 1)
    }

    /// Maximum
    public func max() -> Element {
        var result: Element = 0.0
        vDSP_maxvD(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Minimum
    public func min() -> Element {
        var result: Element = 0.0
        vDSP_minvD(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Mean
    public func mean() -> Element {
        var result: Element = 0.0
        vDSP_meanvD(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Mean Magnitude
    public func meamg() -> Element {
        var result: Element = 0.0
        vDSP_meamgvD(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Mean Square Value
    public func measq() -> Element {
        var result: Element = 0.0
        vDSP_measqvD(self, 1, &result, vDSP_Length(count))

        return result
    }

    /// Square Root
    public func sqrt() -> [Element] {
        var results = [Element](repeating: 0.0, count: count)
        vvsqrt(&results, self, [Int32(count)])

        return results
    }

    /// Addition
    public static func add(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](y)
        cblas_daxpy(Int32(x.count), 1.0, x, 1, &results, 1)

        return results
    }

    /// Subtraction
    public static func sub(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](y)
        catlas_daxpby(Int32(x.count), 1.0, x, 1, -1, &results, 1)

        return results
    }

    /// Multiply
    public static func mul(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vDSP_vmulD(x, 1, y, 1, &results, 1, vDSP_Length(x.count))

        return results
    }

    /// Divide
    public static func div(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vvdiv(&results, x, y, [Int32(x.count)])

        return results
    }

    /// Modulo
    public static func mod(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vvfmod(&results, x, y, [Int32(x.count)])

        return results
    }

    /// Remainder
    public static func remainder(_ x: [Element], _ y: [Element]) -> [Element] {
        var results = [Element](repeating: 0.0, count: x.count)
        vvremainder(&results, x, y, [Int32(x.count)])

        return results
    }

    /// Dot Product
    public static func dot(_ x: [Element], _ y: [Element]) -> Element {
        precondition(x.count == y.count, "Vectors must have equal count")

        var result: Element = 0.0
        vDSP_dotprD(x, 1, y, 1, &result, vDSP_Length(x.count))

        return result
    }

    /// Distance
    public static func dist(_ x: [Element], _ y: [Element]) -> Element {
        precondition(x.count == y.count, "Vectors must have equal count")
        let sub = x - y
        var squared = [Element](repeating: 0.0, count: x.count)
        vDSP_vsqD(sub, 1, &squared, 1, vDSP_Length(x.count))

        return squared.sum().squareRoot()
    }

    public static func + (lhs: [Element], rhs: [Element]) -> [Element] {
        return add(lhs, rhs)
    }

    public static func + (lhs: [Element], rhs: Element) -> [Element] {
        return add(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func - (lhs: [Element], rhs: [Element]) -> [Element] {
        return sub(lhs, rhs)
    }

    public static func - (lhs: [Element], rhs: Element) -> [Element] {
        return sub(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func / (lhs: [Element], rhs: [Element]) -> [Element] {
        return div(lhs, rhs)
    }

    public static func / (lhs: [Element], rhs: Element) -> [Element] {
        return div(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func * (lhs: [Element], rhs: [Element]) -> [Element] {
        return mul(lhs, rhs)
    }

    public static func * (lhs: [Element], rhs: Element) -> [Element] {
        return mul(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func % (lhs: [Element], rhs: [Element]) -> [Element] {
        return mod(lhs, rhs)
    }

    public static func % (lhs: [Element], rhs: Element) -> [Element] {
        return mod(lhs, [Element](repeating: rhs, count: lhs.count))
    }

    public static func • (lhs: [Element], rhs: [Element]) -> Element {
        return dot(lhs, rhs)
    }
}
