//
//  Uncurry.swift
//  Surge
//
//  Created by Matteo Battaglio on 29/06/2017.
//  Copyright © 2017 Mattt Thompson. All rights reserved.
//

func uncurry<Input, Output>(_ f: @escaping (Input) -> () -> Output) -> (Input) -> Output {
    return { input in
        f(input)()
    }
}
