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

public enum MatrixAxis {
    case row
    case column
}

public struct Matrix<Element> where Element: BinaryFloatingPoint {
    fileprivate let rows: Int
    fileprivate let columns: Int
    fileprivate var grid: [Element]

    public init(rows: Int, columns: Int, repeatedValue: Element) {
        self.rows = rows
        self.columns = columns

        self.grid = [Element](repeating: repeatedValue, count: rows * columns)
    }

    public init(_ contents: [[Element]]) {
        let m: Int = contents.count
        let n: Int = contents[0].count
        let repeatedValue: Element = 0.0 

        self.init(rows: m, columns: n, repeatedValue: repeatedValue)

        for (i, row) in contents.enumerated() {
            grid.replaceSubrange(i*n..<i*n+Swift.min(m, row.count), with: row)
        }
    }

    public subscript(row: Int, column: Int) -> Element {
        get {
            assert(indexIsValidForRow(row, column: column))
            return grid[(row * columns) + column]
        }

        set {
            assert(indexIsValidForRow(row, column: column))
            grid[(row * columns) + column] = newValue
        }
    }
    
    public subscript(row row: Int) -> [Element] {
        get {
            assert(row < rows)
            let startIndex = row * columns
            let endIndex = row * columns + columns
            return Array(grid[startIndex..<endIndex])
        }
        
        set {
            assert(row < rows)
            assert(newValue.count == columns)
            let startIndex = row * columns
            let endIndex = row * columns + columns
            grid.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }
    
    public subscript(column column: Int) -> [Element] {
        get {
            var result = [Element](repeating: 0.0, count: rows)
            for i in 0..<rows {
                let index = i * columns + column
                result[i] = self.grid[index]
            }
            return result
        }
        
        set {
            assert(column < columns)
            assert(newValue.count == rows)
            for i in 0..<rows {
                let index = i * columns + column
                grid[index] = newValue[i]
            }
        }
    }

    fileprivate func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
}

// MARK: - Printable

extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = ""

        for i in 0..<rows {
            let contents = (0..<columns).map{"\(self[i, $0])"}.joined(separator: "\t")

            switch (i, rows) {
            case (0, 1):
                description += "(\t\(contents)\t)"
            case (0, _):
                description += "⎛\t\(contents)\t⎞"
            case (rows - 1, _):
                description += "⎝\t\(contents)\t⎠"
            default:
                description += "⎜\t\(contents)\t⎥"
            }

            description += "\n"
        }

        return description
    }
}

// MARK: - SequenceType

extension Matrix: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        let endIndex = rows * columns
        var index = 0

        return AnyIterator {
            if index == endIndex {
                return nil
            }

            let currentIndex = index
            index += 1

            return self.grid[currentIndex]
        }
    }
}

extension Matrix: Equatable {
    public static func ==(lhs: Matrix<Element>, rhs: Matrix<Element>) -> Bool {
        return lhs.rows == rhs.rows && lhs.columns == rhs.columns && lhs.grid == rhs.grid
    }
}


extension Matrix where Element == Float {
    public static func add(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.rows == y.rows && x.columns == y.columns, "Matrix dimensions not compatible with addition")

        var results = y
        cblas_saxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(results.grid), 1)

        return results
    }

    public static func sub(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.rows == y.rows && x.columns == y.columns, "Matrix dimensions not compatible with subtraction")

        var results = y.negate()
        cblas_saxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(results.grid), 1)

        return results
    }

    public static func mul(_ alpha: Element, _ x: Matrix<Element>) -> Matrix<Element> {
        var results = x
        cblas_sscal(Int32(x.grid.count), alpha, &(results.grid), 1)

        return results
    }

    public static func mul(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.columns == y.rows, "Matrix dimensions not compatible with multiplication")

        var results = Matrix<Element>(rows: x.rows, columns: y.columns, repeatedValue: 0.0)
        cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(x.rows), Int32(y.columns), Int32(x.columns), 1.0, x.grid, Int32(x.columns), y.grid, Int32(y.columns), 0.0, &(results.grid), Int32(results.columns))

        return results
    }

    public static func elmul(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.rows == y.rows && x.columns == y.columns, "Matrix must have the same dimensions")
        var result = Matrix<Element>(rows: x.rows, columns: x.columns, repeatedValue: 0.0)
        result.grid = x.grid * y.grid
        return result
    }

    public static func div(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        let yInv = y.inv()
        precondition(x.columns == yInv.rows, "Matrix dimensions not compatible")
        return mul(x, yInv)
    }
}

extension Matrix where Element == Double {
    public static func add(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.rows == y.rows && x.columns == y.columns, "Matrix dimensions not compatible with addition")

        var results = y
        cblas_daxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(results.grid), 1)

        return results
    }

    public static func sub(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.rows == y.rows && x.columns == y.columns, "Matrix dimensions not compatible with subtraction")

        var results = y.negate()
        cblas_daxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(results.grid), 1)

        return results
    }

    public static func mul(_ alpha: Element, _ x: Matrix<Element>) -> Matrix<Element> {
        var results = x
        cblas_dscal(Int32(x.grid.count), alpha, &(results.grid), 1)

        return results
    }

    public static func mul(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.columns == y.rows, "Matrix dimensions not compatible with multiplication")

        var results = Matrix<Element>(rows: x.rows, columns: y.columns, repeatedValue: 0.0)
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(x.rows), Int32(y.columns), Int32(x.columns), 1.0, x.grid, Int32(x.columns), y.grid, Int32(y.columns), 0.0, &(results.grid), Int32(results.columns))

        return results
    }

    public static func elmul(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        precondition(x.rows == y.rows && x.columns == y.columns, "Matrix must have the same dimensions")
        var result = Matrix<Element>(rows: x.rows, columns: x.columns, repeatedValue: 0.0)
        result.grid = x.grid * y.grid
        return result
    }

    public static func div(_ x: Matrix<Element>, _ y: Matrix<Element>) -> Matrix<Element> {
        let yInv = y.inv()
        precondition(x.columns == yInv.rows, "Matrix dimensions not compatible")
        return mul(x, yInv)
    }
}


extension Matrix where Element == Float {
    public func pow(_ y: Element) -> Matrix {
        var result = self
        result.grid = grid.pow(y)
        return result
    }

    public func exp() -> Matrix {
        var result = self
        result.grid = grid.exp()
        return result
    }

    public func sum(axis: MatrixAxis = .column) -> Matrix {
        switch axis {
        case .column:
            var result = Matrix(rows: 1, columns: columns, repeatedValue: 0.0)
            for i in 0..<columns {
                result.grid[i] = self[column: i].sum()
            }
            return result

        case .row:
            var result = Matrix(rows: rows, columns: 1, repeatedValue: 0.0)
            for i in 0..<rows {
                result.grid[i] = self[row: i].sum()
            }
            return result
        }
    }

    public func inv() -> Matrix {
        precondition(rows == columns, "Matrix must be square")

        var results = self

        var ipiv = [__CLPK_integer](repeating: 0, count: rows * rows)
        var lwork = __CLPK_integer(columns * columns)
        var work = [CFloat](repeating: 0.0, count: Int(lwork))
        var error: __CLPK_integer = 0
        var nr = __CLPK_integer(rows)
        var nc = __CLPK_integer(columns)
        var lda = nr
        var order = nr

        sgetrf_(&nr, &nc, &(results.grid), &lda, &ipiv, &error)
        sgetri_(&order, &(results.grid), &lda, &ipiv, &work, &lwork, &error)

        assert(error == 0, "Matrix not invertible")

        return results
    }

    public func transpose() -> Matrix {
        var results = self
        vDSP_mtrans(grid, 1, &(results.grid), 1, vDSP_Length(results.rows), vDSP_Length(results.columns))

        return results
    }

    public func negate() -> Matrix<Element> {
        var results = self
        vDSP_vneg(grid, 1, &(results.grid), 1, vDSP_Length(results.grid.count))

        return results
    }
}

extension Matrix where Element == Double {
    public func pow(_ y: Element) -> Matrix {
        var result = self
        result.grid = grid.pow(y)
        return result
    }

    public func exp() -> Matrix {
        var result = self
        result.grid = grid.exp()
        return result
    }

    public func sum(axis: MatrixAxis = .column) -> Matrix {
        switch axis {
        case .column:
            var result = Matrix(rows: 1, columns: columns, repeatedValue: 0.0)
            for i in 0..<columns {
                result.grid[i] = self[column: i].sum()
            }
            return result

        case .row:
            var result = Matrix(rows: rows, columns: 1, repeatedValue: 0.0)
            for i in 0..<rows {
                result.grid[i] = self[row: i].sum()
            }
            return result
        }
    }

    public func inv() -> Matrix {
        precondition(rows == columns, "Matrix must be square")

        var results = self

        var ipiv = [__CLPK_integer](repeating: 0, count: rows * rows)
        var lwork = __CLPK_integer(columns * columns)
        var work = [CDouble](repeating: 0.0, count: Int(lwork))
        var error: __CLPK_integer = 0
        var nr = __CLPK_integer(rows)
        var nc = __CLPK_integer(columns)
        var lda = nr
        var order = nr

        dgetrf_(&nr, &nc, &(results.grid), &lda, &ipiv, &error)
        dgetri_(&order, &(results.grid), &lda, &ipiv, &work, &lwork, &error)

        assert(error == 0, "Matrix not invertible")

        return results
    }

    public func transpose() -> Matrix {
        var results = self
        vDSP_mtransD(grid, 1, &(results.grid), 1, vDSP_Length(results.rows), vDSP_Length(results.columns))

        return results
    }

    public func negate() -> Matrix<Element> {
        var results = self
        vDSP_vnegD(grid, 1, &(results.grid), 1, vDSP_Length(results.grid.count))

        return results
    }
}


// MARK: - Operators

postfix operator ′

extension Matrix where Element == Float {
    public static func + (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .add(lhs, rhs)
    }

    public static func - (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .sub(lhs, rhs)
    }

    public static func * (lhs: Element, rhs: Matrix) -> Matrix {
        return .mul(lhs, rhs)
    }

    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .mul(lhs, rhs)
    }

    public static func / (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .div(lhs, rhs)
    }

    public static func / (lhs: Matrix, rhs: Element) -> Matrix {
        var result = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
        result.grid = lhs.grid / rhs
        return result
    }

    public static postfix func ′ (value: Matrix) -> Matrix {
        return value.transpose()
    }

    public static prefix func - (value: Matrix) -> Matrix {
        return value.negate()
    }
}

extension Matrix where Element == Double {
    public static func + (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .add(lhs, rhs)
    }

    public static func - (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .sub(lhs, rhs)
    }

    public static func * (lhs: Element, rhs: Matrix) -> Matrix {
        return .mul(lhs, rhs)
    }

    public static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .mul(lhs, rhs)
    }

    public static func / (lhs: Matrix, rhs: Matrix) -> Matrix {
        return .div(lhs, rhs)
    }

    public static func / (lhs: Matrix, rhs: Double) -> Matrix {
        var result = Matrix<Double>(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
        result.grid = lhs.grid / rhs
        return result
    }

    public static postfix func ′ (value: Matrix) -> Matrix {
        return value.transpose()
    }

    public static prefix func - (value: Matrix) -> Matrix {
        return value.negate()
    }
}
