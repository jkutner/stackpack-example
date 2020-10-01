.PHONY: clean
clean:
	docker volume rm stackpack-example-layers --force

.PHONY: clean-all
clean-all: clean
	docker volume rm stack-example-cache --force

.PHONY: detect
detect: clean
	docker run --name stackpack-ex --rm -it \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v "$$(pwd)/stack-order.toml":/cnb/stack/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		heroku/buildpacks /cnb/lifecycle/detector -log-level debug

.PHONY: analyze
analyze:
	docker run --name stackpack-ex --rm -it \
		-u 0 \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v "$$(pwd)/stack-order.toml":/cnb/stack/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		-v /var/run/docker.sock:/var/run/docker.sock \
		heroku/buildpacks /cnb/lifecycle/analyzer -log-level debug -daemon -cache-dir /cache myimg

.PHONY: restore
restore:
	docker run --name stackpack-ex --rm -it \
		-u 0 \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v "$$(pwd)/stack-order.toml":/cnb/stack/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		heroku/buildpacks /cnb/lifecycle/restorer -log-level debug -cache-dir /cache

.PHONY: build
build:
	docker run --name stackpack-ex --rm -it \
		-u 0 \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v "$$(pwd)/stack-order.toml":/cnb/stack/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		heroku/buildpacks /cnb/lifecycle/builder -log-level debug

.PHONY: export
export:
	docker run --name stackpack-ex --rm -it \
		-u 0 \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v "$$(pwd)/stack-order.toml":/cnb/stack/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		-v /var/run/docker.sock:/var/run/docker.sock \
		heroku/buildpacks /cnb/lifecycle/exporter -log-level debug -daemon -cache-dir /cache myimg

.PHONY: create
create: clean
	docker run --name stackpack-ex --rm -it \
		-u 0 \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v "$$(pwd)/stack-order.toml":/cnb/stack/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		-v /var/run/docker.sock:/var/run/docker.sock \
		heroku/buildpacks /cnb/lifecycle/creator -log-level debug -daemon -cache-dir /cache myimg

.PHONY: run
run:
	@docker run --name stackpack-ex --rm -it \
		-u 0 \
		-v stackpack-example-layers:/layers \
		-v stack-example-cache:/cache \
		-v "$$(pwd)/stack/buildpacks":/cnb/stack/buildpacks \
		-v "$$(pwd)/buildpacks":/cnb/buildpacks \
		-v "$$(pwd)/order.toml":/cnb/order.toml \
		-v /Users/jesse.brown/dev/buildpacks/lifecycle/out/linux/lifecycle/lifecycle:/cnb/lifecycle/lifecycle \
		-v /Users/jesse.brown/dev/heroku/go-getting-started:/workspace \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v docker:/root/.docker/ \
		-v docker:/heroku/.docker/ \
		heroku/buildpacks

.PHONY: clean-build
clean-build: clean-all detect build export

.PHONY: rebuild
rebuild: clean detect analyze restore build export