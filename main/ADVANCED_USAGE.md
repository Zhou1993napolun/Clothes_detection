# Advanced Usage

**BEFORE** building the local Docker image, you can change the default deployment options by modifying the contents of the `main` folder.

* [Change Inference Device](#change-inference-device)
* [Change Broker](#change-broker)
* [Change Input](#change-input)
* [Change Models](#change-models)
* [Choose Datasets](#choose-datasets)
* [Save Output](#save-output)
* [Turn off Display](#turn-off-display)

## Change Inference Device

The default inference device is CPU, it can be changed to use GPU or Intel's Neural Compute Stick 2 (NCS2) instead.

See the [installation guide](https://software.intel.com/content/www/us/en/develop/articles/get-started-with-neural-compute-stick.html) before using Intel's NCS2.

Edit `main/activate.sh`, add an additional argument to the last command:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	...
	...
	# Use GPU
	--device GPU  	 # or -d GPU
	# Use Intel's NCS2
	--device MYRIAD	 # or -d MYRIAD
```

If you use Intel's NCS2 as the inference device, use the following command to open the Docker container after building the image:

```bash
docker run -it -e DISPLAY=unix$DISPLAY -e GDK_SCALE -e GDK_DPI_SCALE \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /dev/bus/usb:/dev/bus/usb \
	--device /dev/dri:/dev/dri \
	--device-cgroup-rule='c 189:* rmw' USERNAME/REPOSITORY:TAG
```

## Change Broker

The default IP address of the context broker can be changed by editing `main/result_publisher.py`:

```python
# Change the following IPv4 address and the port number to your broker's
ORION_HOST_PORT = os.getenv("ORION_HOST_PORT", "IPv4:port")
```

The broker service can be disabled if you do not want to send messages to any context broker. Remove the `output_broker` argument in `main/activate.sh`:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	...
	...
	--output_broker # remove this argument to disable the service
```

## Change Input

The default input is the IP address of a Raspberry Pi Camera Module, which can be changed by editing `main/activate.sh`:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \	# camera IDs / camera IP addresses / path to video files
	...
	...
```

If you use video files as the input, make sure to add them into the `main` folder.

## Change Models

The fashion detection model is replaceable. Place your own IR (Intermediate Representation) files into `main/models`, and change the model path in `main/activate.sh`:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	--m ... \	# path to the your own model (.xml)
	...
	...
```

### Convert your models to IR

See the [OpenVINO IR converting guide](https://docs.openvinotoolkit.org/latest/openvino_docs_MO_DG_prepare_model_convert_model_Converting_Model.html) to convert your own models to IR.

The following shows an **example** that converts a YOLOv3 model to IR.

#### 1. Prepare your YOLOv3 model

Download a YOLOv3 fashion detection model from [Google Drive](https://drive.google.com/file/d/1P2BtqrIKbz2Dtp3qfPCkvp16bj9xSVIw/view?usp=sharing).

#### 2. Convert the DarkNet `.weights` file to `.pb` file

* Set up the environment

  ```bash
  conda create -n tf1 python=3.5
  conda activate tf1
  pip install tensorflow==1.11.0 pillow
  ```

* Clone the repositories

  ```bash
  # The repository that contains model configuration files
  git clone https://github.com/simaiden/Clothing-Detection.git
  
  # The repository for converting
  git clone https://github.com/mystic123/tensorflow-yolo-v3.git
  cd tensorflow-yolo-v3
  git checkout ed60b90
  ```

* Run the conversion script

  ```bash
  python3 convert_weights_pb.py \
  	--class_names ../Clothing-Detection/yolo/df2cfg/df2.names \
  	--data_format NHWC \
  	--weights_file $PATH_TO_YOUR_MODEL/yolov3-df2_15000.weights
  ```

  This will generate a `frozen_darknet_yolov3_model.pb` file.

#### 3. Convert the `.pb` file to IR

* Modify OpenVINO's `yolo_v3.json` file

  ```bash
  sudo vim /opt/intel/openvino_2021/deployment_tools/model_optimizer/extensions/front/tf/yolo_v3.json
  ```

  Change the content of `yolo_v3.json` as follows:

  ```json
  [
    {
      "id": "TFYOLOV3",
      "match_kind": "general",
      "custom_attributes": {
        "classes": 13,
        "anchors": [10, 13, 16, 30, 33, 23, 30, 61, 62, 45, 59, 119, 116, 90, 156, 198, 373, 326],
        "coords": 4,
        "num": 9,
        "mask":[6, 7, 8],
        "entry_points": ["detector/yolo-v3/Reshape", "detector/yolo-v3/Reshape_4", "detector/yolo-v3/Reshape_8"]
      }
    }
  ]
  ```

* Run the conversion script

  ```bash
  cd /opt/intel/openvino_2021/deployment_tools/model_optimizer
  sudo python3 mo_tf.py \
  	--input_model $PATH_TO_PB/frozen_darknet_yolov3_model.pb \
  	--transformations_config extensions/front/tf/yolo_v3.json \
  	--data_type FP16 --batch 1 \
  	--output_dir $OUTPUT_DIRECTORY
  ```

  This will generate the final IR files (`.bin`, `.mapping`, and `.xml`).

### Model architecture type

If your model's architecture type is different than YOLOv3, you may need to change the `-at` argument in `main/activate.sh` as well:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	--m ... \	# path to the your own model (.xml)
	-at ... \	# choose your model's architecture type
	...
	...
```

You can choose from these following types: {ssd, yolo, yolov4, faceboxes, centernet, ctpn, retinaface, ultra_lightweight_face_detection, retinaface-pytorch}.

## Choose Datasets

Different datasets use different fashion item categories. In order for the inference results to match the desired category names, you need to specify the dataset used to train your fashion detection model.

You can change the `-ds` argument in `main/activate.sh`:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	...
	-ds ... \	# choose dataset name {df2, modanet}, default is df2
	...
	...
```

Currently supported datasets are [DeepFashion2](https://github.com/switchablenorms/DeepFashion2) and [ModaNet](https://github.com/eBay/modanet), use `-ds df2` for the former and `-ds modanet` for the latter.

## Save Output

The output detection and tracking history files can be saved in local directory. Use the following command to open the Docker container after building the image:

```bash
docker run -it -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
	-v $PATH_TO_LOCAL_DIRECTORY:/opt/intel/openvino/main/logs \
    -u 0 USERNAME/REPOSITORY:TAG
```

If you want the output video (MP4) to be saved as well, edit the `main/activate.sh` before building the image:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	...
	...
	-o main/logs/output_video.mp4	# add this argument
```

## Turn off Display

You can turn off the real-time display window by adding the `--no_show` argument in `main/activate.sh`:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	...
	...
	--no_show	# add this argument
```

You can also choose not to show the detection results in the terminal by removing the `-r` argument:

```bash
python3 deployment_tools/open_model_zoo/demos/... \
	-i ... \
	...
	-r \	# remove this argument
	...
```

