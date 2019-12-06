#[macro_use]
extern crate rustler;

use rustler::{Encoder, Env, Error, Term};
use std::convert::{TryFrom, TryInto};

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Day2.Vm",
    [
        ("run", 1, run)
    ],
    None
}

#[derive(PartialEq, Eq)]
enum OpCode {
    Add = 1,
    Mult = 2,
    Quit = 99,
}

impl TryFrom<i64> for OpCode {
    type Error = Error;

    fn try_from(v: i64) -> Result<Self, Self::Error> {
        match v {
            x if x == OpCode::Add as i64 => Ok(OpCode::Add),
            x if x == OpCode::Mult as i64 => Ok(OpCode::Mult),
            x if x == OpCode::Quit as i64 => Ok(OpCode::Quit),
            _ => Err(Error::RaiseAtom("invalid_opcode")),
        }
    }
}

fn run<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let mut memory: Vec<i64> = args[0].decode()?;

    for (idx, op) in memory.to_owned().into_iter().enumerate().step_by(4) {
        let read_reg_a = memory[idx + 1] as usize;
        let read_reg_b = memory[idx + 2] as usize;
        let write_reg = memory[idx + 3] as usize;

        match op.try_into() {
            Ok(OpCode::Add) => {
                memory[write_reg] = memory[read_reg_a] + memory[read_reg_b];
            }

            Ok(OpCode::Mult) => {
                memory[write_reg] = memory[read_reg_a] * memory[read_reg_b];
            }

            _ => break,
        }
    }

    Ok((atoms::ok(), memory).encode(env))
}
