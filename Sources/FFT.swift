// FFT.swift
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

// MARK: Fast Fourier Transform

extension Array where Element == Float {
    public func fft() -> [Element] {
        var real = self
        var imaginary = [Element](repeating: 0.0, count: count)
        var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)

        let length = vDSP_Length(Darwin.floor(Darwin.log2(Element(count))))
        let radix = FFTRadix(kFFTRadix2)
        let weights = vDSP_create_fftsetup(length, radix)
        vDSP_fft_zip(weights!, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))

        var magnitudes = [Element](repeating: 0.0, count: count)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(count))

        var normalizedMagnitudes = [Element](repeating: 0.0, count: count)
        vDSP_vsmul(magnitudes.sqrt(), 1, [2.0 / Element(count)], &normalizedMagnitudes, 1, vDSP_Length(count))

        vDSP_destroy_fftsetup(weights)

        return normalizedMagnitudes
    }
}

extension Array where Element == Double {
    public func fft() -> [Element] {
        var real = self
        var imaginary = [Element](repeating: 0.0, count: count)
        var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)

        let length = vDSP_Length(Darwin.floor(Darwin.log2(Element(count))))
        let radix = FFTRadix(kFFTRadix2)
        let weights = vDSP_create_fftsetupD(length, radix)
        vDSP_fft_zipD(weights!, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))

        var magnitudes = [Element](repeating: 0.0, count: count)
        vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(count))

        var normalizedMagnitudes = [Element](repeating: 0.0, count: count)
        vDSP_vsmulD(magnitudes.sqrt(), 1, [2.0 / Element(count)], &normalizedMagnitudes, 1, vDSP_Length(count))

        vDSP_destroy_fftsetupD(weights)

        return normalizedMagnitudes
    }
}
