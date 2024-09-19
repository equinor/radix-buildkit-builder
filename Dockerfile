FROM ghcr.io/jqlang/jq:1.7.1 AS jq

FROM quay.io/buildah/stable:v1.37.1 AS buildah 

COPY --from=jq /jq /usr/local/bin/jq

COPY --chmod=111 build.sh /usr/local/bin/build.sh

ENTRYPOINT [ "build.sh" ]