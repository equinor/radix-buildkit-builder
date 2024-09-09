# radix-buildkit-builder



## Readonly root filesystem

Required writable directories:
- /home/build
- /var


docker buildx build --tag nilsgustavstrabo/radix-buildkit-builder --platform=linux/amd64,linux/arm64 --push .

# https://www.atatus.com/blog/bash-scripting/