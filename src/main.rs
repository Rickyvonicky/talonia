use log::info;
use directories::ProjectDirs;
use dirs::home_dir;
use std::fs;
use std::fmt::Display;
use std::path::PathBuf;
use foundation314::config::read_csv;  // Import function directly
use foundation314::config::get_config_dir;  // Import function directly
use foundation314::config::get_data_dir;  // Import function directly
use foundation314::config::groot;  // Import function directly



fn main() {
    println!("groot :{}",groot());
    println!("{}",get_data_dir().display());


    let filepath = String::from("/home/ray/.talonia/worlds/burgs.csv");
    //let csvdata=read_csv(&filepath);
    // let csvdata=foundation314::config::read_csv(&filepath);
    // println!("{:?}", csvdata);

    env_logger::init();

    let project_dirs = ProjectDirs::from("com", "LANHOUSE", env!("CARGO_PKG_NAME"))
        .expect("Failed to determine project directories");

    let config_dir = project_dirs.config_dir();
    let data_dir = project_dirs.data_dir();

    println!("App Name: {}", env!("CARGO_PKG_NAME"));
    println!("Config Directory: {:?}", config_dir);
    //println!("Data Directory: {:?}", data_dir);
    println!(">>>Data Directory :{}",get_data_dir().display());
    

    info!("App started successfully!");
    
    let app_name = env!("CARGO_PKG_NAME");
    // Get the user's home directory
    let home_dir = home_dir().expect("Could not determine home directory");

    // Create the hidden directory path
    let app_dir = home_dir.join(format!(".{}", app_name));
    // Create the directory if it doesn't exist
    if !app_dir.exists() {
        fs::create_dir_all(&app_dir).expect("Failed to create app directory");
        println!("Created directory: {:?}", app_dir);
    } else {
        println!("Directory already exists: {:?}", app_dir);
    }
}

