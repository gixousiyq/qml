use cstr::cstr;
use qmetaobject::prelude::*;
use std::fs;

// The `QObject` custom derive macro allows to expose a class to Qt and QML
#[derive(QObject, Default)]
struct VersesGrabber {
    // Specify the base class with the qt_base_class macro
    base: qt_base_class!(trait QObject),
    // Grab verses from src/current_page file
    grab_verses: qt_method!(fn grab_verses(&self) -> QString {
        fs::read_to_string("src/current_page").expect("").into()
    })
}

fn main() {
    // Register the `Greeter` struct to QML
    qml_register_type::<VersesGrabber>(cstr!("VersesGrabber"), 1, 0, cstr!("VersesGrabber"));
    // Create a QML engine from rust
    let mut engine = QmlEngine::new();

    engine.load_file("src/main.qml".into());
    engine.exec();
}