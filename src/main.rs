pub fn bar() {
    #[cfg(feature = "python")]
    println!("Eggs!");
    #[cfg(not(feature = "python"))]
    println!("Baz!");
}

fn main() {
    bar();
}
