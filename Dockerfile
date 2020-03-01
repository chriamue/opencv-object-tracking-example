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
RUN /darknet/darknet detector train detector.data custom.cfg /darknet/yolov3.weights
RUN cd /darknet && ./darknet detector test /custom_data/detector.data /custom_data/custom.cfg /custom_data/backup/custom_final.weights /custom_data/test.jpg

FROM python:3.7
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY main.py /app
COPY --from=trainer /custom_data/custom.cfg .
COPY --from=trainer /custom_data/custom.names .
COPY --from=trainer /custom_data/backup/custom_final.weights .
COPY --from=trainer /custom_data/test.jpg .
CMD ["python", "main.py"]
