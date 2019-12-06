#[macro_use]
extern crate rustler;

use rustler::{Encoder, Env, Error, Term};

mod atoms {
    rustler_atoms! {
        atom ok;
        // atom error;
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Day1.Calculator",
    [
        ("calculate", 1, calculate)
    ],
    None
}

fn calculate<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let mass: i64 = args[0].decode()?;
    let mut fuel = (mass / 3) - 2;

    if fuel < 0 {
        fuel = 0;
    }

    Ok((atoms::ok(), fuel).encode(env))
}
