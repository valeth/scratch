fn main()
{
    let mut n = 3;

    if n < 0 {
        println!("negative number");
    } else if n > 0 {
        println!("positive number");
    } else {
        println!("zero");
    }

    'whooo: loop {
        loop {
            if n == 0 {
                println!("bye");
                break 'whooo;
            } else {
                println!("spinning");
            }

            n -= 1;
        }
    }

    let mut x = 1;

    while x < 10 {
        if x % 15 == 0 {
            println!("fizzbuzz");
        } else if x % 3 == 0 {
            println!("fizz");
        } else if x % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", x);
        }

        x += 1;
    }

    for y in 1..10 {
        println!("{}", y);
    }

    let boolean = true;

    match boolean {
        false => println!("{} -> {}", boolean, 0),
        true  => println!("{} -> {}", boolean, 1)
    }
}
