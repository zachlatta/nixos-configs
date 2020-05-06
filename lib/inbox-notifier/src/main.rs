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
        let entry = entry?;
        let path = entry.path();
        let metadata = fs::metadata(&path)?;

        let filename = path.file_name()
            .ok_or("no filename")?
            .to_str()
            .ok_or("unable to render filename")?;

        // Ignore README and .git directory
        if filename == "README.md" || filename == ".git" || filename == "vip-newsletters-to-open-source" {
            continue
        }

        // Print heading if we haven't already
        if !printed_heading {
            println!("You've got files in your inbox!\n");

            printed_heading = true;
        }

        println!(
            " - {}, created on {}",
            filename,
            DateTime::<Local>::from(metadata.created()?).format("%Y-%m-%d")
        );
    }

    Ok(())
}
