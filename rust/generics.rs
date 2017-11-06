// concrete types
struct A;

struct Single(A);

// generic type
struct SingleGen<T>(T);

// generic functions
fn generic_spec(_x: A) {}

fn generic<T>(_x: SingleGen<T>) {}

#[derive(Debug)]
struct Val {
    val: f64
}

#[derive(Debug)]
struct GenVal<T> {
    gen_val: T
}

impl Val {
    fn value(&self) -> &f64 { &self.val }
}

// generic implementation
impl <T> GenVal<T> {
    fn value(&self) -> &T { &self.gen_val }
}

trait DoubleDrop<T> {
    fn double_drop(self, _: T);
}

impl<T, U> DoubleDrop<T> for U {
    fn double_drop(self, _: T) {}
}

fn main() {
    let _s = Single(A);

    // explicitly specified type
    let _char: SingleGen<char> = SingleGen('a');

    // implicitly specified type
    let _char = SingleGen('b');

    generic_spec(A);

    // explicit function call
    generic::<u32>(SingleGen(13));

    // implicit function call
    generic(SingleGen(14));

    let x = Val { val: 3.0 };

    let y = GenVal { gen_val: 3i32 };

    println!("{}, {}", x.value(), y.value());

    x.double_drop(y);

    // values moved
    // println!("{:?}", x);
    // println!("{:?}", y);
}
