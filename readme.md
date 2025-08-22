# Proyecto PiFeNet

Este proyecto utiliza dependencias externas que deben estar presentes antes de construir la imagen de Docker. Para facilitar esto, se proporciona un script `setup.sh`.

## Dependencias externas

El proyecto depende de los siguientes repositorios:

- **PiFeNet**: [https://github.com/ldtho/PiFeNet.git](https://github.com/ldtho/PiFeNet.git)  
- **spconv** (versión 1.2.1): [https://github.com/traveller59/spconv.git](https://github.com/traveller59/spconv.git)

Estos repositorios deben clonarse dentro de la carpeta `external/` en la raíz del proyecto.
Para docker ros: https://github.com/2b-t/velodyne-ros2-docker?tab=readme-ov-file (con modificaciones para usar ros1 en vez de ros2)
Además, a nivel de sistema, se requiere instalar el Nvidia Container Toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

---

## Uso de `setup.sh`

Se recomienda usar el script `setup.sh` para clonar automáticamente las dependencias externas.  

```bash
# Desde la raíz del proyecto
chmod +x setup.sh
./setup.sh
```

## DEBUG PERSONAL

NVIDIA RUNTIME en build
- https://forums.developer.nvidia.com/t/nvidia-docker-runtime-does-not-seem-to-work-with-docker-compose/307879/2
- https://forums.developer.nvidia.com/t/docker-build-with-nvidia-runtime/272767
- https://forums.developer.nvidia.com/t/whats-difference-between-gpus-and-runtime-nvidia-for-the-docker-container/283468/4
- https://developer.nvidia.com/container-runtime

EJECUTAR SVCONV

sudo docker compose --verbose run --rm pifenet
y después en otra ventana
sudo docker compose exec -it pifenet bash
