#!/bin/bash

make clean
make
./cjpeg test.bmp test.jpeg
./cjpeg test2.bmp test2.jpeg