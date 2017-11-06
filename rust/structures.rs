#![allow(dead_code)]

#[derive(Debug)]
struct Triple(u8, u8, u8);

#[derive(Debug)]
struct Nil;

#[derive(Debug)]
enum Professions {
    Programmer,
    Electrician,
    Carpenter,
    Cook
}

fn main()
{
    println!("{:?}", Triple(16u8, 14u8, 19u8));

    use Professions::{Programmer, Electrician};

    println!("{:?}", Programmer);
    println!("{:?}", Electrician);
}
