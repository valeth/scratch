mod mymod {
    // public struct with public field
    pub struct WhiteBox<T> {
        pub contents: T
    }

    // public struct with private field
    #[allow(dead_code)]
    pub struct BlackBox<T> {
        contents: T
    }

    impl<T> BlackBox<T> {
        pub fn new(contents: T) -> BlackBox<T> {
            BlackBox {
                contents: contents
            }
        }
    }

    fn private_fn() {
        println!("called mymod::private_fn()");
    }

    pub fn fun() {
        println!("called mymod::fun()");
    }

    pub fn indirect() {
        println!("calling mymod::private_fn() over mymod::indirect()");
        private_fn();
        self::private_fn();
    }

    pub mod submod {
        pub fn fun() {
            println!("called mymod::submod::fun()");
            super::fun();
        }
    }
}

fn main() {
    // can't call private function
    // mymod::private_fn();

    mymod::fun();
    mymod::indirect();
    mymod::submod::fun();

    let white_box = mymod::WhiteBox {
        contents: "some public content"
    };

    println!("WhiteBox: {}", white_box.contents);

    let _black_box = mymod::BlackBox::new("you can't see me");

    // can't access, contents field is private
    // println!("BlackBox: {}", _black_box.contents);

    use mymod::submod::fun as myfun;
    myfun();

    use mymod::fun;
    fun();
}
