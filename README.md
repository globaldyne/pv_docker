To build the image:

	docker build -t perfumersvault .	

or to build specific branch:

	docker build --build-arg git_repo=v8.2 -t perfumersvault:v8.2 .
