#![crate_type = "lib"]
// #![crate_name = "rary"]

pub fn pubfun() {
    println!("hello there");
}

fn privfun() {
    println!("nyaa~");
}

pub fn peek() {
    println!("let's take a look");
    privfun();
    println!("oh, it's a kitty, how cute");
}
