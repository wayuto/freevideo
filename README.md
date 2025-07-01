# ***freevideo***
*Feel free to watch video without VIP.*  

# ***Building***
- ## *Step 1: Clone this repo and enter to the directorvim y*  
```bash
git clone https://github.com/wayuto/freevideo.git --depth 1
cd freevideo
```

- ## *Step 2: Install the requirements*
```bash
flutter pub get
```
- ### *(Optional) If you want to upgrade the requirements*
```bash
flutter pub outdated
flutter flutter pub upgrade --major-versions
```

- ## *Step 3: Build a release version*
```
flutter build apk --release [-v](optional)
```

- ### *(Optional) Install the apk to your phone*
```bash
adb devices
# If nothing showed, execute following command
adb pair ip:port
adb connect ip:port

# After connecting your phone
flutter install
```

# ***Something to talk***
## *About cross-platform*
- *This app currently doesn't support `GitHub Page` because this app parses and plays videos by `WebView`.*  
- *So now it currently only support `Android` platform.*  
- *I'm so sorry, I'll make it work on `Github Page` soon.*