# opencv-object-tracking-example
Object Tracking written in python, bundled in docker.

## quickstart

Test local on host machine.

```bash
virtualenv venv -p python3
source venv/bin/activate
pip install -r requirements.txt
python main.py
```

## change classes count

We will need to update the classes and filters params of [yolo] and [convolutional] layers that are just before the [yolo] layers.
In this example since we have a single class we will update the classes param in the [yolo] layers to 1 at line numbers: 610, 696, 783
Similarly we will need to update the filters param based on the classes count filters=(classes + 5) * 3. For a single class we should set filters=18 at line numbers: 603, 689, 776

## Credits

Based on [OpenCV Object Tracking](https://www.pyimagesearch.com/2018/07/30/opencv-object-tracking/)
and [https://blog.francium.tech/custom-object-training-and-detection-with-yolov3-darknet-and-opencv-41542f2ff44e](https://blog.francium.tech/custom-object-training-and-detection-with-yolov3-darknet-and-opencv-41542f2ff44e)

Images in custom_data/images where downloaded from [https://unsplash.com/s/photos/pen](https://unsplash.com/s/photos/pen)