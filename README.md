# movie_app
**API Reference**
This project uses the KKPhim API for streaming movies. Refer to the API documentation for details on available endpoints and usage.

## SETUP pubspec packages used:
0. **environment, dependencies, dev:**
    ```sh
    environment:
    sdk: '>=3.4.0 <4.0.0'
    dependencies:
    flutter:
        sdk: flutter
    cupertino_icons: ^1.0.6
    http: ^1.2.1
    webview_flutter: ^4.7.0
    video_player: ^2.2.14
    chewie: ^1.1.2
    flutter_html: ^3.0.0-beta.2
    salomon_bottom_bar: ^3.3.2
    carousel_slider: ^4.2.1
    jwt_decoder: ^2.0.1
    velocity_x: ^4.1.2
    shared_preferences: ^2.0.6

    dev_dependencies:
    flutter_test:
        sdk: flutter
    flutter_lints: ^3.0.0

    flutter:
    uses-material-design: true
    ```
    ```sh
    flutter pub add salomon_bottom_bar
    ```

1. **Type flutter:**
   ```sh
   flutter clean
   ```
   ```sh
   flutter pub get / flutter upgrade
   ```
   ```sh
   flutter run
   ```

## Screenshoot APP
### Home & Search page:
![home_page](images/image-4.png)
![search_page](images/image-5.png)

### Film & Detail page:
![film_page](images/image-3.png)
![detail_page](images/image-2.png)

### Play page:
![play_page](images/image.png)
![play_page_fullScreen](images/image-1.png)
