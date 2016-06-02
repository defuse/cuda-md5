All: md5kernel.o md5.o main.cu
	nvcc -arch=sm_35 -o md5Gpu main.cu


clean:
	rm *.o
	rm md5
