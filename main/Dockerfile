FROM openvino/ubuntu18_dev:latest

USER root
WORKDIR /opt/intel/openvino/

# Add main files
COPY main main
RUN chmod -R 777 main

# Install OpenVINO demos's dependencies
RUN apt-get update \
    && apt-get -y install sudo vim libswscale-dev libavformat-dev gstreamer1.0-plugins-base --fix-missing \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Fashion Detection requirements
RUN pip3 install celery==5.1.2

# Update modified Python scripts
COPY main/fashion_detection.py deployment_tools/open_model_zoo/demos/object_detection_demo/python
COPY main/result_publisher.py deployment_tools/open_model_zoo/demos/object_detection_demo/python

# Automatically activate Fashion Detection
CMD ["main/activate.sh"]

USER openvino
