To build the image:

	docker build -t jbvault .	

or to build specific branch:

	docker build --build-arg git_repo=v2.8 -t jbvault:v2.8 .
