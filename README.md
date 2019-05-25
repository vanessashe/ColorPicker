# ColorPicker
This app is a live color picker which helps you easily fetch accurate colors in real time.

<div align="center">
<img src="https://github.com/vanessashe/ColorPicker/raw/master/Images/colorPicker-demo-1.gif" width="180" />
<img src="https://github.com/vanessashe/ColorPicker/raw/master/Images/colorPicker-demo-2.gif" width="180" />
</div>

### How to get pixel color from an image/video?
To get the pixel color data from the video output buffer,
first we have to calculate the coordinate of the touched point from user interface to the video output buffer.
Then, translate the YCbCr value into RGB value.

see ColorPicker/ColorPicker/HomePage/HomeViewController.swift & ColorPicker/ColorPicker/HomePage/helper/PixelBufferTool.swift
