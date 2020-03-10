# Face Identifier

This project is based on the use of Flutter's plugin for Firebase ML Vision.

## Features

This app allows you to take a picture either from your gallery or directly from the camera. It then identifes faces in the image and draws red squares around them.

## Working

- The image is selected using a Flutter plugin called **ImagePicker**. 
- The image is analyzed and faces are identified using **Firebase's ML Vision**.
- The image is repainted using **CustomPainter** and red squares are drawn around the faces.

## Reference

This app is based on the following videos released on Flutter's Youtube Channel.

Here are the links for further reference:
* [Computer Vision with ML Kit](https://www.youtube.com/watch?v=ymyYUCrJnxU&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2&index=11)
* [Custom painting in Flutter](https://www.youtube.com/watch?v=vvI_NUXK00s&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2&index=13)
