
```bash
#
wget https://github.com/mugimugi555/jetsonnano/raw/refs/heads/main/ubuntu20/realesrgan/realesrgan-ncnn-vulkan
chmod +x realesrgan-ncnn-vulkan

#
wget 'https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg?raw=true' -O input.jpg
./realesrgan-ncnn-vulkan -i input.jpg -o output.jpg -s 2 -m models -n realesrgan-x4plus
```
