//
//  Queue.swift
//  atc
//
//  Created by Vincent Fumo on 9/12/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

public struct Queue<T> {
    fileprivate var list = LinkedList<T>()
    
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else {
            return nil
        }
        
        list.remove(node: element)
        
        return element.value
    }
    
    public func peek() -> T? {
      return list.first?.value
    }
    
    public var isEmpty: Bool {
      return list.isEmpty
    }
}

extension Queue: CustomStringConvertible {

  public var description: String {
    return list.description
  }
}
