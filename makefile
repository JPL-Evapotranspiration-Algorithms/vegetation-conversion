PACKAGE_NAME = vegetation-conversion
ENVIRONMENT_NAME = $(PACKAGE_NAME)
DOCKER_IMAGE_NAME = $(PACKAGE_NAME)

.PHONY: clean test build twine-upload dist remove-environment install uninstall reinstall environment colima-start docker-build docker-build-environment docker-build-installation docker-interactive docker-remove

clean:
	rm -rf *.o *.out *.log
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf .pytest_cache
	find . -type d -name "__pycache__" -exec rm -rf {} +

test:
	pytest

build:
	python -m build

twine-upload:
	twine upload dist/*

dist:
	$(MAKE) clean
	$(MAKE) build
	$(MAKE) twine-upload

remove-environment:
	mamba env remove -y -n $(ENVIRONMENT_NAME)

install:
	pip install -e .[dev]

uninstall:
	pip uninstall $(PACKAGE_NAME)

reinstall:
	$(MAKE) uninstall
	$(MAKE) install

environment:
	mamba create -y -n $(ENVIRONMENT_NAME) -c conda-forge python=3.10

colima-start:
	colima start -m 16 -a x86_64 -d 100

docker-build:
	docker build -t $(DOCKER_IMAGE_NAME):latest .

docker-build-environment:
	docker build --target environment -t $(DOCKER_IMAGE_NAME):latest .

docker-build-installation:
	docker build --target installation -t $(DOCKER_IMAGE_NAME):latest .

docker-interactive:
	docker run -it $(DOCKER_IMAGE_NAME) fish

docker-remove:
	docker rmi -f $(DOCKER_IMAGE_NAME)
