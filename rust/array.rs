use std::mem;

fn main()
{
    let xs: [u32; 4] = [1, 2, 3, 4];

    println!("{}", mem::size_of_val(&xs[0 .. 4]))
}
