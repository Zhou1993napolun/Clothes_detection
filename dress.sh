#!/bin/bash
#
# Set OpenVINO Environment Variables

source /opt/intel/openvino_2021/bin/setupvars.sh

# Activate real-time Dress Detection 

echo -e "Commencing real-time Dress Detection\n"

#python3 ~/qmh/openvino_2021/deployment_tools/open_model_zoo/demos/object_detection_demo/python/demo1.py \
#	-i 'http://pi:raspberry@192.168.12.150:8090/stream.mjpg' \
#	-m /home/ubuntu/qmh/models/ir/yolov3-df2.xml \
#	-at yolo \
#	-ds df2 \
#	--output_limit 0 \
#	-d CPU \
#	-r \
#	-o ~/Documents/fashion_demo/logs/dress_output.mp4 \
#	--save_detections ~/Documents/fashion_demo/logs/detections.json


python3 ~/qmh/openvino_2021/deployment_tools/open_model_zoo/demos/object_detection_demo/python/demo1.py \
	-i ~/Videos/test_phone_cut.mp4 \
	-m /home/ubuntu/qmh/models/ir/yolov3-modanet.xml \
	-at yolo \
	-ds modanet \
	--output_limit 0 \
	-d CPU \
	-r
	# -o ~/Documents/fashion_demo/logs/dress_output.mp4 \
	# --save_detections ~/Documents/fashion_demo/logs/detections.json \
	# --output_broker
