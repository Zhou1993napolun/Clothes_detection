# Additional Notes on the Project

This project is base on the `openvino` environment. So if we want to start this project, we should setup our `openvino` environment first.



After setup our python virtual environment. (eg. my environment name is openvino)

 ```shell
source activate openvino
 ```

We should wakeup the `openvino` environment. 

If you are the first time down the openvino structure, we should use flow these shell command. ( eg. My openvino pass is `/opt/intel/` )

```shell
cd /opt/intel/openvino/deployment_tools/model_optimizer/install_prerequisites
sudo ./install_prerequisites.sh
```

If you all ready setup the openvino structure, you can only use this command to wake up it.

```shell
source /opt/intel/openvino_2021/bin/setupvars.sh
```

Then up this project to the pass `your_openvino_pass/openvino_2021/deployment_tools/open_model_zoo/demoobject_detection_demo/python/`

