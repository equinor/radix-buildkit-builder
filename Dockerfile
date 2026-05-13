FROM ghcr.io/jqlang/jq:1.7.1 AS jq

FROM quay.io/buildah/stable:v1.43.1 AS buildah

RUN rm -f /etc/containers/registries.conf.d/000-shortnames.conf

COPY --from=jq /jq /usr/local/bin/jq

COPY --chmod=111 build.sh /usr/local/bin/build.sh
COPY ./registries.conf /etc/containers/

ENTRYPOINT [ "build.sh" ]
