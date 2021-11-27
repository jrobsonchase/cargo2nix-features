pub fn say_it() {
    #[cfg(feature = "python")]
    println!("Eggs!");
    #[cfg(not(feature = "python"))]
    println!("Baz!");
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
