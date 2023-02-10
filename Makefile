#!/usr/bin/make
# Makefile readme (ru): <http://linux.yaroslavl.ru/docs/prog/gnu_make_3-79_russian_manual.html>
# Makefile readme (en): <https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents>

SHELL = /bin/bash

include ./.env

HOST_IS_SET=$(shell grep $(APP_DOMAIN) /etc/hosts)

.DEFAULT_GOAL: help

# This will output the help for each task. thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## Show this help
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: build
build: ## Build containers
	@$(MAKE) stop
	docker-compose build

.PHONY: init
init: ## Make full application initialization
	@$(MAKE) stop
	docker-compose up -d
ifeq (,$(wildcard ./src/.env))
	rm ./src/.gitkeep
	docker-compose exec php-fpm-8 composer create-project laravel/laravel .
	touch ./src/.gitkeep
endif
	docker-compose exec php-fpm-8 composer install --ansi --prefer-dist
	@rm -f ./src/public/storage
	docker-compose exec php-fpm-8 php artisan storage:link
	@$(MAKE) --no-print-directory start
	@$(MAKE) set_host

.PHONY: start
start: ## Create and start containers
	docker-compose up -d --remove-orphans
	@printf "\n ⠿\e[30;32m %s \033[0m\n" 'Application available at http://$(APP_DOMAIN)';

.PHONY: stop
stop: ## Stop containers
	docker-compose down -v --remove-orphans

.PHONY: shell sh
shell: ## Start shell into app container
	docker-compose exec -ti php-fpm-8 bash
sh: shell

.PHONY: set_host
set_host: ## Set link in /etc/hosts
ifneq ($(shell grep $(APP_DOMAIN) /etc/hosts), )
	@echo "/etc/hosts already updated"
else
	sudo sh -c "echo \"\n127.0.0.1  ${APP_DOMAIN}\" >> /etc/hosts"
	@echo "/etc/hosts updated"
endif
