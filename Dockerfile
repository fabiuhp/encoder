ARG GO_VERSION=1.26.5
ARG ALPINE_VERSION=3.24

ARG BENTO4_VERSION=1-6-0-641
ARG BENTO4_SHA256=8258faf0de7253f2aac016018f33d4a04c16d9060735e14ec8711f84aaedf0c8

FROM alpine:${ALPINE_VERSION} AS bento4-builder

ARG BENTO4_VERSION
ARG BENTO4_SHA256

RUN apk add --no-cache \
        build-base \
        ca-certificates \
        cmake \
        ninja \
        unzip \
        wget

WORKDIR /tmp

RUN set -eux; \
    BENTO4_ARCHIVE="Bento4-SRC-${BENTO4_VERSION}.zip"; \
    BENTO4_URL="https://www.bok.net/Bento4/source/${BENTO4_ARCHIVE}"; \
    \
    wget -qO "${BENTO4_ARCHIVE}" "${BENTO4_URL}"; \
    echo "${BENTO4_SHA256}  ${BENTO4_ARCHIVE}" | sha256sum -c -; \
    unzip -q "${BENTO4_ARCHIVE}"; \
    \
    cmake \
        -S "Bento4-SRC-${BENTO4_VERSION}" \
        -B /tmp/bento4-build \
        -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/bento4; \
    \
    cmake --build /tmp/bento4-build --parallel; \
    cmake --install /tmp/bento4-build; \
    \
    mkdir -p /opt/bento4/utils; \
    cp -R \
        "Bento4-SRC-${BENTO4_VERSION}/Source/Python/utils/." \
        /opt/bento4/utils/; \
    \
    find \
        "Bento4-SRC-${BENTO4_VERSION}/Source/Python/wrappers" \
        -type f \
        ! -name "*.bat" \
        -exec cp {} /opt/bento4/bin/ \;; \
    \
    chmod +x /opt/bento4/bin/*

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}

ENV BENTO4_HOME="/opt/bento4" \
    BENTO4_BIN="/opt/bento4/bin" \
    PATH="/opt/bento4/bin:${PATH}"

RUN apk add --no-cache \
        bash \
        build-base \
        ca-certificates \
        ffmpeg \
        git \
        python3

COPY --from=bento4-builder /opt/bento4 /opt/bento4

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]