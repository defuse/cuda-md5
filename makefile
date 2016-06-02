All: md5Kernel.cu
	nvcc -arch=sm_35 -o md5 md5kernel.cu md5.cu

clean:
	rm *.o
	rm md5
