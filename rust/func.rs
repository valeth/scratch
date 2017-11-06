#![allow(dead_code)]
#![allow(unused_variables)]

use std::fmt::{Formatter, Display, Result};
use std::mem;

fn plus_ten(x: i32) -> i32 {
    x + 10
}

fn hello()
{
    println!("Hello!");
}

struct Point {
    x: f64,
    y: f64
}

// implementation block with 2 static methods
impl Point {
    fn origin() -> Point
    {
        Point { x: 0.0, y: 0.0 }
    }

    fn new(x: f64, y: f64) -> Point
    {
        Point { x: x, y: y }
    }
}

impl Display for Point {
    fn fmt(&self, f: &mut Formatter) -> Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

struct Rectangle {
    p1: Point,
    p2: Point
}

impl Rectangle {
    // instance method
    // &self <-> self: &Rectangle
    fn area(&self) -> f64 {
        let Point { x: x1, y: y1 } = self.p1;
        let Point { x: x2, y: y2 } = self.p2;
        ((x1 - x2) * (x1 - y2)).abs()
    }

    fn perimeter(&self) -> f64 {
        let Point { x: x1, y: y1 } = self.p1;
        let Point { x: x2, y: y2 } = self.p2;

        2.0 * ((x1 - x2).abs() + (y1 - y2).abs())
    }

    // &mut self <-> self: &mut Rectangle
    fn translate(&mut self, x: f64, y: f64) {
        self.p1.x += x;
        self.p2.x += x;
        self.p1.y += y;
        self.p2.y += y;
    }
}

impl Display for Rectangle {
    fn fmt(&self, f: &mut Formatter) -> Result {
        write!(f, "[{}, {}]", self.p1, self.p2)
    }
}

fn apply<F>(mut f: F) where
    F: FnMut() {
        f();
    }

fn main() {
    println!("plus ten: {}", plus_ten(20));
    hello();

    let rect = Rectangle {
        p1: Point::origin(),
        p2: Point::new(6.4, 3.2)
    };

    println!("rectangle: {}", rect);
    println!("perimeter: {}", Rectangle::perimeter(&rect)); // this works
    println!("area: {}", rect.area()); // as does this, &rect is passed implicitly

    let closure  = |i: u32| -> u32 { i + 1 };
    let inferred = |i| i + 1;

    println!("closure: {}", closure(10));
    println!("inferred: {}", inferred(10));

    let mut count = 0;

    let mut inc = || {
        count += 1;
        println!("count: {}", count);
    };

    inc();
    inc();
    inc();

    // this won't work, count is already borrowed
    // let reborrow = &mut count;

    let movable = Box::new(4);

    let consume = || {
        println!("movable: {:?}", movable);
        mem::drop(movable);
    };

    consume();

    // can't use moved value
    // consume();

    apply(inc);
}
