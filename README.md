# radix-buildkit-builder

TODO: compose default auth.json

Example usage:
./build.sh --registry "docker.io" --branch main --registry-username nst --registry-password pwd --use-cache --cache-registry cache.io --cache-registry-username cnst --cache-registry-password cpwd --cache-repository myapp/cache --push --tag a:1 --cluster-type-tag a:1-ct --cluster-name-tag a:1-cn --secrets a --secrets b,c,d,1 --secrets-path /mysecrets