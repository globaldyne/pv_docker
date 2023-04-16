To build the image:

	docker build -t pvault .	

or to build specific branch:

	docker build --build-arg git_repo=v6.1 -t pvault:v6.1 .
