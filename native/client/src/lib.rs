#[macro_use] extern crate rustler;
#[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;
extern crate reqwest;

use rustler::{Env, Term, NifResult, Encoder};

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.Client",
    [
        ("add", 2, add),
        ("get_body", 1, get_body)
    ],
    None
}

fn add<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let num1: i64 = try!(args[0].decode());
    let num2: i64 = try!(args[1].decode());

    Ok((atoms::ok(), num1 + num2).encode(env))
}

fn get_body<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let url: String = try!(args[0].decode());

    match reqwest::get(&url) {
        Ok(mut res) => {
            let body = res.text().unwrap();
            Ok((atoms::ok(), body).encode(env))
        },
        Err(err) => {
            Ok((atoms::error(), err.to_string()).encode(env))
        }
    }
}
