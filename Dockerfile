FROM ubuntu:18.04 AS trainer
WORKDIR /root
RUN \
	apt-get update && apt-get install -y \
	autoconf \
    automake \
	libtool \
	build-essential \
	git wget
RUN git clone https://github.com/pjreddie/darknet /darknet
WORKDIR /darknet
RUN make
RUN wget https://pjreddie.com/media/files/yolov3.weights >/dev/null 2>&1
RUN ./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights data/dog.jpg
COPY custom_data /custom_data
WORKDIR /custom_data
RUN ls images/* | grep -v '\.txt' > images.txt
RUN shuf images.txt | split -a1 -d -l $(( $(wc -l <images.txt) * 80 / 100 )) - images
RUN mv images0 train.txt && mv images1 test.txt
RUN cat train.txt
RUN mkdir -p backup
RUN /darknet/darknet detector train detector.data /darknet/cfg/yolov3.cfg /darknet/yolov3.weights
RUN /darknet/darknet detector test detector.data /darknet/cfg/yolov3.cfg backup/yolov3_final.weights images/alysha-rosly-2I3zN5tve4Q-unsplash.jpg

FROM python:3.7
COPY . /app
WORKDIR /app
#RUN pip install -r requirements.txt
CMD ["python", "main.py"]