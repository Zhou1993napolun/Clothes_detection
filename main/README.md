# Real-time Fashion Detection Enabler

A real-time fashion (items) detection enabler that uses an IP camera as input, and serves the output data to a context broker.

Based on Intel OpenVINO's [Object Detection Python Demo](https://docs.openvinotoolkit.org/latest/omz_demos_object_detection_demo_python.html), version 2021.3.394.

## Labels / Categories

The list of identifiable fashion item labels / categories may be different depending on which dataset is chosen during the training process.

The default is DeepFashion2, see [ADVANCED_USAGE.md](./ADVANCED_USAGE.md) to change the default dataset.

| Label number | DeepFashion2 dataset | ModaNet dataset |
| :----------: | :------------------: | :-------------: |
|      1       |   short sleeve top   |       bag       |
|      2       |   long sleeve top    |      belt       |
|      3       | short sleeve outwear |      boots      |
|      4       | long sleeve outwear  |    footwear     |
|      5       |         vest         |      outer      |
|      6       |        sling         |      dress      |
|      7       |        shorts        |   sunglasses    |
|      8       |       trousers       |      pants      |
|      9       |        skirt         |       top       |
|      10      |  short sleeve dress  |     shorts      |
|      11      |  long sleeve dress   |      skirt      |
|      12      |      vest dress      |    headwear     |
|      13      |     sling dress      |    scarf/tie    |

## Models

This enabler uses a pre-trained YOLOv3 model as a base object detection model, and two fine-tuned [Clothing-Detection](https://github.com/simaiden/Clothing-Detection) models trained with two different fashion datasets as the final fashion detection models.

* YOLOv3 model trained with [DeepFashion2](https://github.com/switchablenorms/DeepFashion2) dataset: [Google Drive](https://drive.google.com/file/d/1P2BtqrIKbz2Dtp3qfPCkvp16bj9xSVIw/view?usp=sharing).
* YOLOv3 model trained with [ModaNet](https://github.com/eBay/modanet) dataset: [Google Drive](https://drive.google.com/file/d/1Q2sJOodKnoxGBuFA69Dxqv6CD-sqtIKV/view?usp=sharing).

Model configuration files can be found at the [Clothing-Detection](https://github.com/simaiden/Clothing-Detection) GitHub repository.

## Dataset

The models are trained with two different fashion dataset respectively.

* [DeepFashion2](https://github.com/switchablenorms/DeepFashion2)
* [ModaNet](https://github.com/eBay/modanet)

## Quick Deployment

Before deploying this fashion detection enabler, please make sure that a context broker is available.

By default, the context broker is [ORION CONTEXT BROKER](https://fiware-orion.readthedocs.io/en/master/index.html), and its IP address can be changed by setting the environment variable `ORION_HOST_PORT`.

See [ADVANCED_USAGE.md](./ADVANCED_USAGE.md) to change the default IP address.

### Build Docker Image

Under the directory that contains the `Dockerfile` and the `main` folder, run the following command to build a local Docker image (choose your own `USERNAME`, `REPOSITORY` and `TAG`):

```bash
docker build -t USERNAME/REPOSITORY:TAG .
```

### Run Docker Container

Run the following command to open a container which activates the real-time fashion detection:

```bash
docker run -it -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix USERNAME/REPOSITORY:TAG
```

Press `ESC` to properly stop the process. Using `CTRL+C` will interrupt the process BEFORE output messages can be sent to the broker.

## Advanced Usage

See [ADVANCED_USAGE.md](./ADVANCED_USAGE.md).

