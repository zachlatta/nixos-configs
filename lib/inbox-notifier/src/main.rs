extern crate chrono;

use chrono::prelude::*;
use std::fs;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(long)]
    dir: std::path::PathBuf,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Cli::from_args();

    let mut printed_heading = false;

    for entry in fs::read_dir(args.dir)? {
        if !printed_heading {
            println!("You've got files in your inbox!\n");

            printed_heading = true;
        }

        let entry = entry?;
        let path = entry.path();
        let metadata = fs::metadata(&path)?;

        println!(
            " - {}, created on {}",
            path.file_name()
                .ok_or("no filename")?
                .to_str()
                .ok_or("unable to render filename")?,
            DateTime::<Local>::from(metadata.created()?).format("%Y-%m-%d")
        );
    }

    if printed_heading {
        println!(""); // extra line at end to look nice
    }

    Ok(())
}
