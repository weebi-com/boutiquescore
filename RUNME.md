cd C:\Users\PierreGancel\Documents\github\ml_algo\example\wasm
dart compile wasm web/main.dart -o site/test.wasm
cd site
dart pub global run dhttpd --path . --port 8080
