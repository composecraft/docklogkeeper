GIT_VERSION?=$(shell git rev-parse --short HEAD)
run:
	@echo "$(GIT_VERSION)"
	docker build --no-cache --build-arg GIT_VERSION=$(GIT_VERSION) -t "nightlord189/docklogkeeper:latest" .
	docker stop docklogkeeper || true
	docker rm docklogkeeper || true
	docker run --name docklogkeeper -d -v /var/run/docker.sock:/var/run/docker.sock -v docklogkeeper:/logs -p 3010:3010 nightlord189/docklogkeeper:latest

.PHONY: publish
image ?= nightlord189/docklogkeeper:latest
GIT_VERSION?=$(shell git rev-parse --short HEAD)
publish:
	@echo "$(GIT_VERSION)"
	@docker buildx rm multi-platform-builder || true
	@docker buildx create --use --platform=linux/arm64/v8,linux/amd64 --name multi-platform-builder
	@docker buildx inspect --bootstrap
	@docker buildx build --no-cache \
		--build-arg GIT_VERSION=$(GIT_VERSION) \
		--platform linux/arm64/v8,linux/amd64 \
		--tag $(image) \
		.
	@docker buildx rm multi-platform-builder

runbib:
	docker build --no-cache -t "bibgen:latest" ./test/bibgen
	docker stop bibgen || true
	docker rm bibgen || true
	docker run -d --name bibgen bibgen:latest

runrandom:
	docker build --no-cache -t "randomgen:latest" ./test/randomgen
	docker stop randomgen || true
	docker rm randomgen || true
	docker run -d --name randomgen -d randomgen:latest

swag:
	swag init --dir ./cmd/app --parseDependency --parseInternal

deploy:
	rm deploy.tar || true
	tar -cvf ./deploy.tar  ./*
	caprover deploy -t ./deploy.tar --host https://captain.app.tinygreencat.dev --caproverPassword ${CAPROVER_PASSWORD} --appName docklogkeeper
	rm deploy.tar

migrate-new:
	goose -s -dir configs/migrations/local create $(name) sql

migrate:
	goose -dir configs/migrations/local sqlite3 ./logs.db up

migrate-down:
	goose -dir configs/migrations/local sqlite3 ./logs.db down

migrate-reset:
	goose -dir configs/migrations/local sqlite3 ./logs.db reset