use List::*;

enum List {
    Cons(u32, Box<List>),
    Nil
}

impl List {
    fn new() -> List {
        Nil
    }

    fn prepend(self, elem: u32) -> List {
        Cons(elem, Box::new(self))
    }

    fn append(self, elem: u32) -> List {
        match self {
            Cons(e, tail) => Cons(e, Box::new(tail.append(elem))),
            Nil           => Cons(elem, Box::new(self))
        }
    }

    fn len(&self) -> u32 {
        match *self {
            Cons(_, ref tail) => 1 + tail.len(),
            Nil               => 0
        }
    }

    fn stringify(&self) -> String {
        match *self {
            Cons(head, ref tail) => {
                format!("{}, {}", head, tail.stringify())
            },
            Nil => {
                format!("Nil")
            }
        }
    }
}

fn main() {
    let mut list = List::new();

    list = list.prepend(1);
    println!("{}", list.stringify());

    list = list.prepend(2);
    println!("{}", list.stringify());

    list = list.prepend(3);
    println!("{}", list.stringify());

    list = list.append(4);
    println!("{}", list.stringify());

    list = list.append(5);
    println!("{}", list.stringify());

    println!("{}", list.len());
}
