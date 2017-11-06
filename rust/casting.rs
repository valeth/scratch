fn main()
{
    let dec = 67.123_f32;

    let int = dec as u8;
    let ch  = dec as u8 as char;

    println!("{} -> {} -> {}", dec, int, ch);
}
